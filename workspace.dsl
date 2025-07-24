workspace "Digital Screening" "All 6 pathway, currentxly" {
	
	model {
		archetypes {
			screening_service = softwareSystem "Screening Service" {
				tag "Screening Service"
			}
			external_shared_component = softwareSystem "External Shared Component" {
				tag "External Shared Component"
			}
		}
		
		// Diabetic Eye Screening (DES) Pathway
		gpes = external_shared_component "GPES"
		gpdc = softwareSystem "GP Data Collector (GPDC)"
		quicksilva = softwareSystem "Quicksilva"
		
		des_screening_service = screening_service "DES Screening Service"
		gpes -> gpdc
		gpdc -> quicksilva
		quicksilva -> des_screening_service
		
		// Breast Screening Pathway

		gpms = softwareSystem "GP Management Systems and Secondary Care"
		pds = external_shared_component "Personal Demographics Service (PDS)"
		pi = softwareSystem "PI"
		caas = external_shared_component "Cohorting as a Service (CAAS)"
		cohort_manager = softwareSystem "Cohort Manager"
		bs_select = softwareSystem "BS Select"
		nbss = softwareSystem "National Breast Screening Service (NBSS)"
		bsis = softwareSystem "Breast Screening Information Service (BSIS)"
		local_pacs = softwareSystem "Local Picture and Archiving System (PACS)"
		group "Mobile Clinics" {
			daybook = softwareSystem "Daybook"
			modality = softwareSystem "Modality"
			nbss_worklist_server = softwareSystem "NBSS Worklist Server"
		}
		static_unit_modalities = softwareSystem "Static Unit Modalities"
		lims = softwareSystem "Lab Information Systems (LIMS)"
		shim = softwareSystem "SHIM"
		ncras = softwareSystem "NCRAS"
		encore = softwareSystem "ENCORE"
		local_pas = softwareSystem "Local Patient Administration System (PAS)"
		local_ris = softwareSystem "Local Radiology Information System (RIS)"
		
		gpms -> pds "provide registrations and demographics"
		pds -> pi "provide registrations and demographics"
		pi -> bs_select "perform dq check, send demographic updates"
		
		bs_select -> nbss "send registration changes, select eligible persons for invitation, send registration changes"
		nbss -> bs_select "send screening episode outcomes"
		nbss -> gpms "send screening results (letter)"
		bs_select -> bsis "data services: KC63"
		
		pds -> caas
		caas -> cohort_manager
		cohort_manager -> nbss
		nbss -> bsis "KC62 as CSV upload"
		nbss_worklist_server -> modality "appointments loaded from a USB stick onto a laptop in vans"
		nbss -> local_pacs "send patient updates and scheduled procedures"
		local_pacs -> nbss "procedure updates"
		local_pacs -> modality "provide worklist"
		local_pacs -> static_unit_modalities "provide worklist"
		daybook -> nbss "import attendees from vans"
		modality -> local_pacs "push images"
		lims -> nbss "outcomes from labs"
		nbss -> shim "screening data"
		shim -> nbss "result data; categorisation for outcomes with cancer diagnosis"
		shim -> encore "combines data for cancer registration"
		shim -> ncras "combines data for cancer registration"
		local_pas -> local_ris "provide demographics"
		
		// Cervical Screening Pathway
		csms = softwareSystem "CSMS"
		cervical_home_testing = softwareSystem "Cervical Home Testing"
		dps = softwareSystem "DPS"
		pds -> csms
		csms -> cervical_home_testing
		cervical_home_testing -> csms
		csms -> dps
		
		// Bowel Screening Pathway
		bcss = softwareSystem "BCSS"
		obiee = softwareSystem "OBIEE"
		pi -> bcss
		bcss -> obiee
	}
	
	configuration {
		scope softwaresystem
	}
	
	views {
		systemContext nbss "NBSSSystemContext" {
		 	include nbss bsis bs_select cohort_manager caas pi pds daybook modality nbss_worklist_server local_pacs gpms lims shim ncras encore static_unit_modalities local_pas local_ris
			
		}
		
		
		theme default
		
		styles {
			element "External Shared Component" {
				background #999900
			}
			element "Screening Service" {
				background #0099FF
			}

		}
	}
}