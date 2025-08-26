workspace "Digital Screening" "All 6 pathway, currently" {
	
	model {
		archetypes {
			nhs_shared_component = softwareSystem "NHS England Shared Component" {
				tag "NHS England Shared Component"
			}
			external_system = softwareSystem "External System" {
				tag "External System"
			}
			outsourced_system = softwareSystem "Outsourced System" {
				tag "Outsourced System"
			}
			digital_screening_system = softwareSystem "Digital Screening System" {
				tag "Digital Screening System"
			}
		}
		
		
		
		gpes = nhs_shared_component "GPES"
		gpms = external_system "GP Management Systems and Secondary Care" "Provides Registration & demographic feed"
		pds = nhs_shared_component "Personal Demographics Service (PDS)" "Provides Demographics feed, Management of cohort, Identify criteria SDRS"
		pi = digital_screening_system "PI" "Data Quality Checks & Demogaraphics, Aggregations, support by a Bureau team of DQ experts"
		caas = nhs_shared_component "Cohorting as a Service (CAAS)"
		gp2drs = digital_screening_system "GP2DRS"
		cis2 = nhs_shared_component "CIS2"
		mesh = nhs_shared_component "MESh"
		
		// Breast Screening Pathway specific systems
		cohort_manager = digital_screening_system "Cohort Manager"
		bs_select = digital_screening_system "BS Select"
		nbss = digital_screening_system "National Breast Screening Service (NBSS)"
		bsis = digital_screening_system "Breast Screening Information Service (BSIS)"
		iuvo = outsourced_system "Iuvo Clin-ePost"
		local_pacs = external_system "Local Picture and Archiving System (PACS)"
		// BARD is going to be replace by National Disease Registration Service (NDRS) (resusable component)
		bard = external_system "Breastscreening Active Radiotherapy Dataset"
		modality = external_system "Imaging Modality (MRI, Mammography, Ultrasound)"
		lims = external_system "Lab Information Systems (LIMS)"
		
		pds -> pi "provide registrations and demographics"
		pi -> bs_select "perform dq check, send demographic updates"
		bard -> nbss "manual request for adding people to cohort"
		
		bs_select -> iuvo "participant data"
		iuvo -> mesh "participant data"
		mesh -> nbss "participant data"
		
		nbss -> mesh "screening episode outcomes"
		mesh -> iuvo "screening episode outcomes"
		iuvo -> bs_select "screening episode outcomes"
		
		bs_select -> nbss "manual entry of round plan"
		nbss -> gpms "send screening results (letter)"
		bs_select -> bsis "data services: KC63"
		cis2 -> bs_select
		
		pds -> caas
		caas -> cohort_manager
		cohort_manager -> bs_select
		nbss -> bsis "KC62 as manual CSV upload"
		// TODO: explore how NBSS inteacts with PACS machine
		nbss -> local_pacs
		local_pacs -> nbss
		modality -> local_pacs "push images"
		lims -> nbss "manual entry"
		
		// Cervical Screening Pathway
		csms = digital_screening_system "CSMS"
		cervical_home_testing = digital_screening_system "Cervical Home Testing"
		pds -> csms
		csms -> cervical_home_testing
		cervical_home_testing -> csms
		
		// Bowel Screening Pathway
		bcss = digital_screening_system "Bowel Cancer Screening System (BCSS)"
		bowel_obiee = digital_screening_system "Bowel OBIEE"
		fit_analyser = external_system "FIT Analyser"
		fit_middleware = external_system "FIT Middleware"
		group "Specialist Screening" {
			ct_colonoscopy = external_system "CT Colonoscopy"
		}
		epr = external_system "Electronic Patient Record (EPR)"
		rdi = external_system "RDI"
		
		bcss -> bowel_obiee "Magic ETL"
		epr -> bcss
		bcss -> gpms "EDIFACT send outcome"
		pi -> bcss
		bcss -> rdi
		rdi -> fit_middleware
		fit_middleware -> bcss "bespoke REST API"
		bcss -> fit_analyser
		fit_analyser -> fit_middleware "bespoke REST API"
		bcss -> ct_colonoscopy
		
		// AAA Screening Pathway
		aaa = outsourced_system "SMaRT" "Outsourced national system with 38 local providers to access it"
		
		pi -> aaa "Cohort of men due to reach 65 the following year"
		
		// Diabetic Eye Screening (DES) Pathway
		hic = outsourced_system "HIC"
		quicksilva = outsourced_system "Quicksilva"
		des_screening_service = outsourced_system "DES Screening Service"
		
		gpms -> gpes
		gpes -> gp2drs
		gp2drs -> hic
		hic -> quicksilva
		quicksilva -> des_screening_service
	}
	
	configuration {
		scope softwaresystem
	}
	
	views {
		systemLandscape digital_screening "All Systems Context" {
			include *
			autolayout lr
		}
		
		systemContext nbss "Breast_Screening" {
			include nbss bsis bs_select cohort_manager caas pi pds modality local_pacs gpms lims bard iuvo cis2 mesh
			autolayout lr
		}
		
		systemContext bcss "Bowel_Screening" {
			include bcss epr gpms pds pi bowel_obiee fit_analyser fit_middleware rdi ct_colonoscopy
			autolayout lr
		}
		systemContext aaa "AAA_Screening" {
			include aaa pi
			autolayout lr
		}
		systemContext des_screening_service "Diabetic_Eye_Screening" {
			include gpms gpes gp2drs hic des_screening_service quicksilva
			autolayout lr
		}
		
		systemContext csms "Cervical_Screening" {
			include csms cervical_home_testing pds
			autolayout lr
		}
		
		theme default
		
		styles {
			element "Digital Screening System" {
				background #009639
				color #ffffff
			}
			element "NHS England Shared Component" {
				background #FFD700
				color #222222
			}
			element "Outsourced System" {
				background #6EC1E4
				color #222222
			}
			element "External System" {
				background #A2AAAD
				color #222222
			}
			element "Future" {
				icon "https://upload.wikimedia.org/wikipedia/commons/e/e1/Eo_circle_green_arrow-right.svg"
			}
		}
	}
	
	# Use Graphviz to automatically layout the diagrams
	# https://github.com/structurizr/java/tree/master/structurizr-autolayout
	!script groovy {
		new com.structurizr.autolayout.graphviz.GraphvizAutomaticLayout().apply(workspace);
	}
}