workspace "Digital Screening" "All 6 pathway, currently" {
	
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
		pds = external_shared_component "PDS"
		pi = softwareSystem "PI"
		caas = external_shared_component "Cohorting as a Service (CAAS)"
		cohort_manager = softwareSystem "Cohort Manager"
		bs_select = softwareSystem "BS Select"
		nbss = softwareSystem "NBSS"
		bsis = softwareSystem "BSIS"
		
		pds -> pi
		pi -> bs_select
		bs_select -> nbss
		pds -> caas
		caas -> cohort_manager
		cohort_manager -> nbss
		nbss -> bsis
		
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