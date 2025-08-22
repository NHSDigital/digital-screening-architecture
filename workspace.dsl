workspace "Digital Screening" "All 6 pathway, currently" {
	
	model {
		archetypes {
			screening_service = softwareSystem "Screening Service" {
				tag "Screening Service"
			}
			external_shared_component = softwareSystem "External Shared Component" {
				tag "External Shared Component"
			}
			external_data_user = softwareSystem "External Data User" {
				tag "External Data User"
			}
		}
		
		
		
		gpes = external_shared_component "GPES"
		gpms = external_shared_component "GP Management Systems and Secondary Care" "Provides Registration & demographic feed"
		pds = external_shared_component "Personal Demographics Service (PDS)" "Provides Demographics feed, Management of cohort, Identify criteria SDRS"
		pi = softwareSystem "PI" "Data Quality Checks & Demogaraphics, Aggregations, support by a Bureau team of DQ experts"
		caas = external_shared_component "Cohorting as a Service (CAAS)"
		gp2drs = softwareSystem "GP2DRS"
		
		lims = softwareSystem "Lab Information Systems (LIMS)"
		epr = softwareSystem "Electronic Patient Record (EPR)"
		rdi = softwareSystem "RDI"
		
		// Breast Screening Pathway specific systems
		cohort_manager = softwareSystem "Cohort Manager"
		bs_select = softwareSystem "BS Select"
		nbss = screening_service "National Breast Screening Service (NBSS)"
		bsis = screening_service "Breast Screening Information Service (BSIS)"
		local_pacs = softwareSystem "Local Picture and Archiving System (PACS)"
		group "Mobile Clinics" {
			daybook = softwareSystem "Daybook"
			modality = softwareSystem "Modality"
			nbss_worklist_server = softwareSystem "NBSS Worklist Server"
		}
		static_unit_modalities = softwareSystem "Static Unit Modalities"
		
		pds -> pi "provide registrations and demographics"
		pi -> bs_select "perform dq check, send demographic updates"
		
		bs_select -> nbss "send registration changes, select eligible persons for invitation, send registration changes"
		nbss -> bs_select "send screening episode outcomes"
		nbss -> gpms "send screening results (letter)"
		bs_select -> bsis "data services: KC63"
		
		pds -> caas
		caas -> cohort_manager
		cohort_manager -> bs_select
		nbss -> bsis "KC62 as CSV upload"
		nbss_worklist_server -> modality "appointments loaded from a USB stick onto a laptop in vans"
		nbss -> local_pacs "send patient updates and scheduled procedures"
		local_pacs -> nbss "procedure updates"
		local_pacs -> modality "provide worklist"
		local_pacs -> static_unit_modalities "provide worklist"
		daybook -> nbss "import attendees from vans"
		modality -> local_pacs "push images"
		lims -> nbss "outcomes from labs"
		
		// Cervical Screening Pathway
		csms = softwareSystem "CSMS"
		cervical_home_testing = softwareSystem "Cervical Home Testing"
		pds -> csms
		csms -> cervical_home_testing
		cervical_home_testing -> csms
		
		// Bowel Screening Pathway
		bcss = softwareSystem "Bowel Cancer Screening System (BCSS)"
		bowel_obiee = softwareSystem "Bowel OBIEE"
		fit_analyser = softwareSystem "FIT Analyser"
		fit_middleware = softwareSystem "FIT Middleware"
		group "Specialist Screening" {
			ct_colonoscopy = softwareSystem "CT Colonoscopy"
		}
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
		aaa = screening_service "SMaRT" "Outsourced national system with 38 local providers to access it"
		
		group "Reporting" {
			aaadatawarehouse = softwareSystem "Data Warehouse"
			aaaqareporting = softwareSystem "QA Reporting"
		}
		
		pi -> aaa "Cohort of men due to reach 65 the following year"
		aaa -> aaadatawarehouse
		aaadatawarehouse -> aaaqareporting
		
		
		
		// Diabetic Eye Screening (DES) Pathway
		hic = softwareSystem "HIC"
		quicksilva = softwareSystem "Quicksilva"
		des_screening_service = screening_service "DES Screening Service"
		
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
		
		systemContext nbss "NBSSSystemContext" {
			include nbss bsis bs_select cohort_manager caas pi pds daybook modality nbss_worklist_server local_pacs gpms lims static_unit_modalities
			
		}
		
		systemContext bcss "BCSSSystemContext" {
			include bcss epr gpms pds pi bowel_obiee fit_analyser fit_middleware rdi ct_colonoscopy
		}
		systemContext aaa "AAASystemContext" {
			include aaa pi aaadatawarehouse aaaqareporting
		}
		systemContext des_screening_service "DESSystemContext" {
			include gpms gpes gp2drs hic des_screening_service quicksilva
		}
		
		theme default
		
		styles {
			element "External Shared Component" {
				background #999900
			}
			element "Screening Service" {
				background #0099FF
			}
			element "External Data User" {
				background #6c18ff
			}
		}
	}
}