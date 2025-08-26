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
		iuvo = softwareSystem "Iuvo"
		local_pacs = softwareSystem "Local Picture and Archiving System (PACS)"
		// BARD is going to be replace by National Disease Registration Service (NDRS) (resusable component)
		bard = softwareSystem "Breastscreening Active Radiotherapy Dataset" {
			tag "External System"
		}
		modality = softwareSystem "Imaging Modality (MRI, Mammography, Ultrasound)"
		
		pds -> pi "provide registrations and demographics"
		pi -> bs_select "perform dq check, send demographic updates"
		bard -> nbss "manual request for adding people to cohort"
		
		bs_select -> iuvo "cohort"
		iuvo -> nbss "send screening episode outcomes"
		nbss -> bs_select "send screening episode outcomes (MESH)"
		bs_select -> nbss "manual entry of round plan"
		nbss -> gpms "send screening results (letter)"
		bs_select -> bsis "data services: KC63"
		
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
		
		systemContext nbss "Breast_Screening" {
			include nbss bsis bs_select cohort_manager caas pi pds modality local_pacs gpms lims bard iuvo
			autolayout lr
		}
		
		systemContext bcss "Bowel_Screening" {
			include bcss epr gpms pds pi bowel_obiee fit_analyser fit_middleware rdi ct_colonoscopy
			autolayout lr
		}
		systemContext aaa "AAA_Screening" {
			include aaa pi aaadatawarehouse aaaqareporting
			autolayout lr
		}
		systemContext des_screening_service "Diabetic_Eye_Screening" {
			include gpms gpes gp2drs hic des_screening_service quicksilva
			autolayout lr
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
	
	# Use Graphviz to automatically layout the diagrams
	# https://github.com/structurizr/java/tree/master/structurizr-autolayout
	!script groovy {
		new com.structurizr.autolayout.graphviz.GraphvizAutomaticLayout().apply(workspace);
	}
}