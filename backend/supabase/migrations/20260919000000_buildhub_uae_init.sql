-- ==============================================================================
-- BuildHub UAE: Construction, Civil Engineering & Procurement Super-App
-- Complete Supabase PostgreSQL Schema & Security Policies (Step 1)
-- Tailored for UAE Market (Dubai Municipality, RTA, DEWA, MOHRE, FTA VAT 5%)
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
-- Note: PostGIS is available on Supabase for Geo-fencing & 200m radius checks
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 2. CUSTOM ENUMS & TYPES
CREATE TYPE user_role_enum AS ENUM (
    'super_admin',
    'client_developer',
    'consultant_engineer',
    'main_contractor',
    'project_manager',
    'site_engineer',
    'hse_officer',
    'procurement_specialist',
    'subcontractor',
    'vendor_supplier',
    'site_worker'
);

CREATE TYPE uae_authority_enum AS ENUM (
    'DUBAI_MUNICIPALITY',
    'RTA',
    'DEWA',
    'DUBAI_CIVIL_DEFENSE',
    'TRA_DUBAI',
    'ABU_DHABI_DMT',
    'ETIHAD_WEAP',
    'SHARJAH_SEWA'
);

CREATE TYPE submittal_status_enum AS ENUM (
    'PENDING_SUBMISSION',
    'UNDER_CONSULTANT_REVIEW',
    'APPROVED_CODE_A',
    'APPROVED_COMMENTS_CODE_B',
    'REJECTED_CODE_C'
);

CREATE TYPE fidic_contract_type_enum AS ENUM (
    'RED_BOOK_CONSTRUCTION',
    'YELLOW_BOOK_DESIGN_BUILD',
    'SILVER_BOOK_EPC_TURNKEY',
    'GREEN_BOOK_SHORT_FORM'
);

CREATE TYPE ticket_severity_enum AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL_STOP_WORK'
);

CREATE TYPE ticket_status_enum AS ENUM (
    'OPEN',
    'IN_CORRECTION',
    'PENDING_REINSPECTION',
    'RESOLVED_CLOSED'
);

CREATE TYPE escrow_status_enum AS ENUM (
    'FUNDS_DEPOSITED',
    'MILESTONE_INSPECTION_PENDING',
    'VERIFIED_QR_DELIVERED',
    'RELEASE_APPROVED',
    'DISPUTED_HOLD'
);

CREATE TYPE currency_code_enum AS ENUM (
    'AED',
    'SAR',
    'USD'
);

-- ==============================================================================
-- 3. CORE MULTI-TENANCY & IDENTITY TABLES
-- ==============================================================================

-- 3.1 Organizations (Main Contractors, Engineering Consultancies, Developers, Suppliers)
CREATE TABLE IF NOT EXISTS public.organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trade_license_no VARCHAR(100) NOT NULL UNIQUE,
    trade_license_authority uae_authority_enum DEFAULT 'DUBAI_MUNICIPALITY',
    trn VARCHAR(20) NOT NULL, -- UAE Tax Registration Number (15 digits)
    name_ar VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    org_type VARCHAR(50) NOT NULL, -- 'DEVELOPER', 'CONSULTANT', 'CONTRACTOR', 'SUPPLIER'
    registered_address TEXT,
    phone_number VARCHAR(30) CHECK (phone_number ~* '^\+971[0-9]{8,9}$'),
    email VARCHAR(255) NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_badge uae_authority_enum[],
    supplier_reliability_index NUMERIC(3, 2) DEFAULT 4.50 CHECK (supplier_reliability_index BETWEEN 0 AND 5.00),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3.2 User Profiles (Linked to Supabase Auth)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES public.organizations(id) ON DELETE SET NULL,
    national_id VARCHAR(50), -- Emirates ID (784-xxxx-xxxxxxx-x)
    emirates_id_expiry DATE,
    engineering_council_reg VARCHAR(100), -- UAE Engineers Society / DM Engineer card
    full_name_ar VARCHAR(255) NOT NULL,
    full_name_en VARCHAR(255) NOT NULL,
    role user_role_enum NOT NULL DEFAULT 'site_engineer',
    phone VARCHAR(30) CHECK (phone ~* '^\+9715[0-9]{8}$'), -- UAE mobile validation (+971 5x xxx xxxx)
    avatar_url TEXT,
    preferred_language VARCHAR(5) DEFAULT 'ar' CHECK (preferred_language IN ('ar', 'en')),
    preferred_numeral_system VARCHAR(10) DEFAULT 'WESTERN' CHECK (preferred_numeral_system IN ('WESTERN', 'EASTERN')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3.3 Projects
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    client_org_id UUID REFERENCES public.organizations(id),
    consultant_org_id UUID REFERENCES public.organizations(id),
    main_contractor_org_id UUID REFERENCES public.organizations(id),
    project_code VARCHAR(50) NOT NULL UNIQUE, -- e.g., DXB-WTC-03
    dm_permit_number VARCHAR(100), -- Dubai Municipality Building Permit
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    contract_type fidic_contract_type_enum DEFAULT 'RED_BOOK_CONSTRUCTION',
    location_point GEOMETRY(Point, 4326), -- GPS Coordinates
    geofence_radius_meters INTEGER DEFAULT 200, -- 200m default site boundary for attendance
    plot_number VARCHAR(100),
    community_name_ar VARCHAR(100),
    community_name_en VARCHAR(100),
    budget_aed NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    contingency_aed NUMERIC(15, 2) DEFAULT 0.00,
    planned_start_date DATE NOT NULL,
    contractual_completion_date DATE NOT NULL,
    current_forecast_completion_date DATE,
    overall_progress_pct NUMERIC(5, 2) DEFAULT 0.00 CHECK (overall_progress_pct BETWEEN 0 AND 100),
    planned_progress_pct NUMERIC(5, 2) DEFAULT 0.00,
    cpi NUMERIC(4, 2) DEFAULT 1.00,
    spi NUMERIC(4, 2) DEFAULT 1.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3.4 Project Team Members & Permissions
CREATE TABLE IF NOT EXISTS public.project_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    project_role user_role_enum NOT NULL,
    can_approve_submittals BOOLEAN DEFAULT FALSE,
    can_sign_wps BOOLEAN DEFAULT FALSE,
    can_authorize_escrow BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(project_id, user_id)
);

-- ==============================================================================
-- 4. PROCUREMENT, BOQ & MATERIAL SUBMITTALS (MODULE 2 & 4)
-- ==============================================================================

-- 4.1 Bill of Quantities (BOQ) Master Lines
CREATE TABLE IF NOT EXISTS public.boq_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    item_code VARCHAR(50) NOT NULL, -- e.g., BOQ-DIV-03.14
    csi_division VARCHAR(10), -- e.g. 03 (Concrete), 05 (Metals), 26 (Electrical)
    description_ar TEXT NOT NULL,
    description_en TEXT NOT NULL,
    unit VARCHAR(30) NOT NULL, -- m3, Ton, m2, lm, No
    quantity NUMERIC(12, 3) NOT NULL CHECK (quantity >= 0),
    unit_rate_aed NUMERIC(12, 2) NOT NULL CHECK (unit_rate_aed >= 0),
    total_amount_aed NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * unit_rate_aed) STORED,
    is_long_lead BOOLEAN DEFAULT FALSE,
    lead_time_weeks INTEGER DEFAULT 0,
    required_site_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4.2 Material Submittals & Approvals Workflow
CREATE TABLE IF NOT EXISTS public.material_submittals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    boq_item_id UUID REFERENCES public.boq_items(id) ON DELETE SET NULL,
    submittal_number VARCHAR(50) NOT NULL, -- e.g., MAT-SUB-014-R1
    revision_number VARCHAR(10) DEFAULT 'R0',
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    supplier_id UUID REFERENCES public.organizations(id),
    manufacturer_name VARCHAR(255),
    country_of_origin VARCHAR(100),
    status submittal_status_enum DEFAULT 'PENDING_SUBMISSION',
    review_code VARCHAR(30), -- 'Code A', 'Code B', 'Code C'
    tds_file_url TEXT,
    msds_file_url TEXT,
    mill_cert_file_url TEXT,
    epd_carbon_cert_url TEXT,
    consultant_remarks_ar TEXT,
    consultant_remarks_en TEXT,
    reviewed_by UUID REFERENCES public.profiles(id),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(project_id, submittal_number, revision_number)
);

-- 4.3 Purchase Orders (Strictly gated by Approved Material Submittal)
CREATE TABLE IF NOT EXISTS public.purchase_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    material_submittal_id UUID NOT NULL REFERENCES public.material_submittals(id),
    po_number VARCHAR(50) NOT NULL UNIQUE,
    supplier_id UUID NOT NULL REFERENCES public.organizations(id),
    total_amount_before_vat_aed NUMERIC(12, 2) NOT NULL,
    vat_rate_pct NUMERIC(4, 2) DEFAULT 5.00,
    vat_amount_aed NUMERIC(12, 2) GENERATED ALWAYS AS (total_amount_before_vat_aed * (vat_rate_pct / 100.00)) STORED,
    total_amount_inc_vat_aed NUMERIC(12, 2) GENERATED ALWAYS AS (total_amount_before_vat_aed * (1.00 + (vat_rate_pct / 100.00))) STORED,
    escrow_enabled BOOLEAN DEFAULT TRUE,
    issued_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4.4 Material Deliveries & Smart QR Receiving
CREATE TABLE IF NOT EXISTS public.material_deliveries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    po_id UUID NOT NULL REFERENCES public.purchase_orders(id) ON DELETE CASCADE,
    delivery_note_number VARCHAR(100) NOT NULL,
    qr_verification_code VARCHAR(128) NOT NULL UNIQUE,
    truck_plate_number VARCHAR(50),
    driver_name VARCHAR(100),
    driver_phone VARCHAR(30),
    transit_mixer_batch_time TIMESTAMP WITH TIME ZONE,
    concrete_max_setting_hours NUMERIC(3, 1) DEFAULT 2.0, -- max 2 hrs under UAE climate for ready-mix
    delivery_status VARCHAR(50) DEFAULT 'IN_TRANSIT', -- 'IN_TRANSIT', 'DELIVERED_PENDING_TEST', 'ACCEPTED_ESCROW_RELEASED', 'REJECTED'
    slump_test_result_mm INTEGER,
    temperature_at_pour_c NUMERIC(4, 1), -- Max 32C as per Dubai Building Code
    inspected_by UUID REFERENCES public.profiles(id),
    received_at TIMESTAMP WITH TIME ZONE,
    gps_delivery_location GEOMETRY(Point, 4326),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- 5. FINANCIAL SUITE, VAT & ESCROW (MODULE 3 & 7)
-- ==============================================================================

-- 5.1 Interim Payment Certificates (IPCs)
CREATE TABLE IF NOT EXISTS public.interim_payment_certificates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    ipc_number VARCHAR(50) NOT NULL, -- e.g., IPC-008
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    gross_certified_amount_aed NUMERIC(15, 2) NOT NULL,
    retention_deduction_pct NUMERIC(4, 2) DEFAULT 10.00, -- Standard 10%
    retention_amount_aed NUMERIC(15, 2) GENERATED ALWAYS AS (gross_certified_amount_aed * (retention_deduction_pct / 100.00)) STORED,
    net_payable_before_vat_aed NUMERIC(15, 2) GENERATED ALWAYS AS (gross_certified_amount_aed - (gross_certified_amount_aed * (retention_deduction_pct / 100.00))) STORED,
    vat_rate_pct NUMERIC(4, 2) DEFAULT 5.00,
    vat_amount_aed NUMERIC(15, 2) GENERATED ALWAYS AS ((gross_certified_amount_aed - (gross_certified_amount_aed * (retention_deduction_pct / 100.00))) * (vat_rate_pct / 100.00)) STORED,
    total_net_payable_inc_vat_aed NUMERIC(15, 2) GENERATED ALWAYS AS ((gross_certified_amount_aed - (gross_certified_amount_aed * (retention_deduction_pct / 100.00))) * (1.00 + (vat_rate_pct / 100.00))) STORED,
    is_signed_by_consultant BOOLEAN DEFAULT FALSE,
    consultant_signed_at TIMESTAMP WITH TIME ZONE,
    payment_status VARCHAR(50) DEFAULT 'PENDING_DISBURSEMENT',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(project_id, ipc_number)
);

-- 5.2 Escrow Vault Accounts & Milestones
CREATE TABLE IF NOT EXISTS public.escrow_milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    po_id UUID REFERENCES public.purchase_orders(id) ON DELETE CASCADE,
    delivery_id UUID REFERENCES public.material_deliveries(id),
    escrow_account_ref VARCHAR(100) NOT NULL,
    milestone_name_ar VARCHAR(255) NOT NULL,
    milestone_name_en VARCHAR(255) NOT NULL,
    amount_aed NUMERIC(15, 2) NOT NULL,
    status escrow_status_enum DEFAULT 'FUNDS_DEPOSITED',
    released_by UUID REFERENCES public.profiles(id),
    released_at TIMESTAMP WITH TIME ZONE,
    digital_signature_hash TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5.3 FIDIC Contractual Claims & 28-Day Clock Tracker
CREATE TABLE IF NOT EXISTS public.fidic_claims (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    notice_reference VARCHAR(100) NOT NULL, -- e.g., CLM-2026-004
    fidic_clause VARCHAR(50) DEFAULT 'Sub-Clause 20.1',
    event_aware_date DATE NOT NULL,
    statutory_deadline_date DATE GENERATED ALWAYS AS (event_aware_date + INTERVAL '28 days') STORED,
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    claimed_cost_aed NUMERIC(15, 2) DEFAULT 0.00,
    claimed_eot_days INTEGER DEFAULT 0,
    is_time_barred BOOLEAN DEFAULT FALSE,
    status VARCHAR(50) DEFAULT 'INITIAL_NOTICE_SUBMITTED',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- 6. SITE SAFETY, GEO-ATTENDANCE & WPS (MODULE 5)
-- ==============================================================================

-- 6.1 Geo-Fenced Workforce Attendance (UAE 200m Site GPS Radius & WPS SIF)
CREATE TABLE IF NOT EXISTS public.site_attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    worker_profile_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    check_in_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT timezone('utc'::text, now()),
    check_out_time TIMESTAMP WITH TIME ZONE,
    check_in_point GEOMETRY(Point, 4326) NOT NULL,
    check_out_point GEOMETRY(Point, 4326),
    is_within_geofence BOOLEAN DEFAULT TRUE,
    mock_location_detected BOOLEAN DEFAULT FALSE,
    wps_routing_code VARCHAR(50), -- SIF Salary Information File reference
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6.2 HSE Safety Shield Tickets (Violations, Hazards & Fine Risk Exposure)
CREATE TABLE IF NOT EXISTS public.safety_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    ticket_number VARCHAR(50) NOT NULL UNIQUE, -- HSE-2026-881
    category VARCHAR(50) NOT NULL, -- 'PPE_VIOLATION', 'HEIGHT_SAFETY', 'SCAFFOLDING', 'HEAT_STRESS', 'FIRE_SAFETY'
    severity ticket_severity_enum DEFAULT 'MEDIUM',
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    location_description TEXT NOT NULL,
    potential_fine_risk_aed NUMERIC(10, 2) DEFAULT 0.00,
    photo_evidence_url TEXT,
    corrective_action_plan TEXT,
    status ticket_status_enum DEFAULT 'OPEN',
    reported_by UUID NOT NULL REFERENCES public.profiles(id),
    assigned_to UUID REFERENCES public.profiles(id),
    closed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6.3 Site Heat-Stress Readings (MOHRE UAE Midday Break & WBGT Monitor)
CREATE TABLE IF NOT EXISTS public.heat_stress_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    ambient_temp_c NUMERIC(4, 1) NOT NULL,
    humidity_pct NUMERIC(4, 1) NOT NULL,
    wbgt_index_c NUMERIC(4, 1) NOT NULL,
    is_midday_break_active BOOLEAN DEFAULT FALSE, -- Mandatory stop 12:30 PM - 3:00 PM (June 15 - Sept 15)
    hydration_break_interval_minutes INTEGER DEFAULT 20,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- 7. CIRCULAR ECONOMY & MATERIAL MARKETPLACE (MODULE 7)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.circular_marketplace_listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    seller_org_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    source_project_id UUID REFERENCES public.projects(id) ON DELETE SET NULL,
    category VARCHAR(50) NOT NULL, -- 'SURPLUS_REBAR', 'CRUSHED_CONCRETE_AGGREGATE', 'SCAFFOLDING_FORMWORK', 'EXCAVATED_FILL'
    title_ar VARCHAR(255) NOT NULL,
    title_en VARCHAR(255) NOT NULL,
    quantity NUMERIC(12, 3) NOT NULL,
    unit VARCHAR(30) NOT NULL,
    unit_price_aed NUMERIC(12, 2) NOT NULL,
    original_purchase_rate_aed NUMERIC(12, 2),
    embodied_co2_saved_kg NUMERIC(12, 2) DEFAULT 0.00, -- EPD / Green Building Credit
    leed_breeam_passport_url TEXT,
    location_emirate VARCHAR(50) DEFAULT 'DUBAI',
    is_escrow_protected BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- 8. INDEXES FOR HIGH-THROUGHPUT PERFORMANCE & GEOSPATIAL SEARCH
-- ==============================================================================

CREATE INDEX IF NOT EXISTS idx_projects_org ON public.projects(organization_id);
CREATE INDEX IF NOT EXISTS idx_projects_active ON public.projects(is_active);
CREATE INDEX IF NOT EXISTS idx_projects_location ON public.projects USING GIST (location_point);

CREATE INDEX IF NOT EXISTS idx_attendance_project_time ON public.site_attendance(project_id, check_in_time);
CREATE INDEX IF NOT EXISTS idx_attendance_point ON public.site_attendance USING GIST (check_in_point);

CREATE INDEX IF NOT EXISTS idx_boq_project_division ON public.boq_items(project_id, csi_division);
CREATE INDEX IF NOT EXISTS idx_submittals_project_status ON public.material_submittals(project_id, status);
CREATE INDEX IF NOT EXISTS idx_deliveries_qr ON public.material_deliveries(qr_verification_code);

CREATE INDEX IF NOT EXISTS idx_safety_project_status ON public.safety_tickets(project_id, status);
CREATE INDEX IF NOT EXISTS idx_claims_project_deadline ON public.fidic_claims(project_id, statutory_deadline_date);

-- Full-Text Search in Arabic & English using GIN
CREATE INDEX IF NOT EXISTS idx_trgm_boq_desc_ar ON public.boq_items USING GIN (description_ar gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_trgm_boq_desc_en ON public.boq_items USING GIN (description_en gin_trgm_ops);

-- ==============================================================================
-- 9. POSTGRESQL FUNCTIONS & AUTOMATION TRIGGERS
-- ==============================================================================

-- 9.1 Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_organizations_updated_at
    BEFORE UPDATE ON public.organizations
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trg_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trg_projects_updated_at
    BEFORE UPDATE ON public.projects
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trg_material_submittals_updated_at
    BEFORE UPDATE ON public.material_submittals
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- 9.2 Auto-check Geofence Proximity (200m radius check)
CREATE OR REPLACE FUNCTION public.check_worker_geofence()
RETURNS TRIGGER AS $$
DECLARE
    project_loc GEOMETRY(Point, 4326);
    allowed_radius INTEGER;
    distance_meters DOUBLE PRECISION;
BEGIN
    SELECT location_point, geofence_radius_meters 
    INTO project_loc, allowed_radius
    FROM public.projects
    WHERE id = NEW.project_id;

    IF project_loc IS NOT NULL AND NEW.check_in_point IS NOT NULL THEN
        -- Compute geodesic distance using PostGIS geography cast
        distance_meters := ST_Distance(project_loc::geography, NEW.check_in_point::geography);
        NEW.is_within_geofence := (distance_meters <= allowed_radius);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_check_worker_attendance_geofence
    BEFORE INSERT ON public.site_attendance
    FOR EACH ROW EXECUTE FUNCTION public.check_worker_geofence();

-- ==============================================================================
-- 10. ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS across all sensitive tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.boq_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.material_submittals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.material_deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interim_payment_certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.escrow_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fidic_claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.safety_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.heat_stress_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circular_marketplace_listings ENABLE ROW LEVEL SECURITY;

-- Helper function: Is member of project
CREATE OR REPLACE FUNCTION public.is_project_member(_project_id UUID, _user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.project_members
        WHERE project_id = _project_id AND user_id = _user_id
    ) OR EXISTS (
        SELECT 1 FROM public.projects p
        JOIN public.profiles pr ON pr.id = _user_id
        WHERE p.id = _project_id AND (
            p.organization_id = pr.organization_id OR 
            p.consultant_org_id = pr.organization_id OR 
            p.main_contractor_org_id = pr.organization_id
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 10.1 Profiles Policies
CREATE POLICY "Users can view profiles in same project or organization"
    ON public.profiles FOR SELECT
    USING (
        auth.uid() = id OR
        organization_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid()) OR
        EXISTS (
            SELECT 1 FROM public.project_members pm1
            JOIN public.project_members pm2 ON pm1.project_id = pm2.project_id
            WHERE pm1.user_id = auth.uid() AND pm2.user_id = profiles.id
        )
    );

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

-- 10.2 Projects Policies
CREATE POLICY "Project members and stakeholder orgs can view project"
    ON public.projects FOR SELECT
    USING (public.is_project_member(id, auth.uid()));

CREATE POLICY "Authorized project managers can update project"
    ON public.projects FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.project_members
            WHERE project_id = projects.id 
              AND user_id = auth.uid()
              AND project_role IN ('project_manager', 'super_admin', 'client_developer')
        )
    );

-- 10.3 Material Submittals Policies
CREATE POLICY "Stakeholders can view project submittals"
    ON public.material_submittals FOR SELECT
    USING (public.is_project_member(project_id, auth.uid()));

CREATE POLICY "Engineers can create submittals"
    ON public.material_submittals FOR INSERT
    WITH CHECK (
        public.is_project_member(project_id, auth.uid())
    );

CREATE POLICY "Consultant engineers can review and stamp submittals"
    ON public.material_submittals FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.project_members
            WHERE project_id = material_submittals.project_id
              AND user_id = auth.uid()
              AND (project_role IN ('consultant_engineer', 'super_admin') OR can_approve_submittals = TRUE)
        )
    );

-- 10.4 Site Attendance Policies
CREATE POLICY "Workers can log their own attendance"
    ON public.site_attendance FOR INSERT
    WITH CHECK (worker_profile_id = auth.uid());

CREATE POLICY "Project managers and HR can view project attendance"
    ON public.site_attendance FOR SELECT
    USING (
        worker_profile_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM public.project_members
            WHERE project_id = site_attendance.project_id
              AND user_id = auth.uid()
              AND project_role IN ('project_manager', 'site_engineer', 'super_admin')
        )
    );

-- 10.5 Safety Tickets Policies
CREATE POLICY "Site staff can view and create safety tickets"
    ON public.safety_tickets FOR SELECT
    USING (public.is_project_member(project_id, auth.uid()));

CREATE POLICY "Site team can report safety violations"
    ON public.safety_tickets FOR INSERT
    WITH CHECK (
        public.is_project_member(project_id, auth.uid()) AND
        reported_by = auth.uid()
    );

CREATE POLICY "HSE Officers and PMs can resolve safety tickets"
    ON public.safety_tickets FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.project_members
            WHERE project_id = safety_tickets.project_id
              AND user_id = auth.uid()
              AND project_role IN ('hse_officer', 'project_manager', 'super_admin')
        )
    );

-- 10.6 Circular Marketplace Policies
CREATE POLICY "Anyone authenticated can view active marketplace listings"
    ON public.circular_marketplace_listings FOR SELECT
    USING (is_active = TRUE);

CREATE POLICY "Registered organizations can publish marketplace surplus"
    ON public.circular_marketplace_listings FOR INSERT
    WITH CHECK (
        seller_org_id = (SELECT organization_id FROM public.profiles WHERE id = auth.uid())
    );
