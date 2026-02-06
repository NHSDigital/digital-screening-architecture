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
    notify = nhs_shared_component "Notify"
    ods = nhs_shared_component "Organisation Data Service (ODS)"
    nhsnet = nhs_shared_component "NHS.Net Exchange"
    dps = nhs_shared_component "Data Provisioning Service (DPS)"

    // Breast Screening Pathway specific systems
    cohort_manager = digital_screening_system "Cohort Manager"
    bs_select = digital_screening_system "BS Select"
    nbss = digital_screening_system "National Breast Screening Service (NBSS)"
    bsis = digital_screening_system "Breast Screening Information Service (BSIS)"
    iuvo = outsourced_system "Iuvo Clin-ePost"
    local_pacs = external_system "Local Picture and Archiving System (PACS)"
    // BARD is going to be replace by National Disease Registration Service (NDRS) (resusable component)
    bard = external_system "Breastscreening Active Radiotherapy Dataset"
    shim = external_system "Screening History Information Management (SHIM)"
    modality = external_system "Imaging Modality (MRI, Mammography, Ultrasound)"
    lims = external_system "Lab Information Systems (LIMS)"

    pds -> pi "provide registrations and demographics"
    pi -> bs_select "perform dq check, send demographic updates"
    bard -> nbss "manual request for adding people to cohort"
    shim -> nbss "ODBC queries via SSH tunnel over the health and social care network"

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
    cis2 -> bsis

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
    capita_notifications = outsourced_system "Capita Notifications"
    pds -> csms "cohort"
    csms -> cervical_home_testing "cohort"
    cervical_home_testing -> csms "invitation flag"
    cis2 -> csms
    csms -> notify "notifications to participants"
    csms -> capita_notifications "letters to participants"
    csms -> nhsnet "Emails to GP Practices"
    lims -> mesh "lab results"
    mesh -> csms "lab results"
    mesh -> gpms "lab results"
    ods -> csms "GP Practice details"
    csms -> dps

    cervical_home_testing_provider = external_system "Cervical Home Testing Provider"
    cervical_home_testing -> cervical_home_testing_provider
    cervical_home_testing -> notify

    // Bowel Screening Pathway
    bcss = digital_screening_system "Bowel Cancer Screening System (BCSS)"
    bowel_obiee = digital_screening_system "Bowel OBIEE"
    fit_middleware = outsourced_system "FIT Kit Middleware" "Provides results from FIT Anlalyser"
    rdi = external_system "RDI"
    ndrs = external_system "NDRS" "National Disease Registration Service"

    bcss -> bowel_obiee "ODI ETL"
    pi -> bcss "Oracle Queues"
    ndrs -> bcss "lynch cohort (high risk)"
    bcss -> rdi "post letters to participants (manual?)"
    fit_middleware -> bcss "FIT results"
    bcss -> fit_middleware "FIT requests"
    bcss -> iuvo "outcome"
    iuvo -> gpms "EDIFACT send outcome"
    cis2 -> bcss
    bcss -> notify "notifications to participants"
    ods -> bcss "Organisation details"

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
      include nbss bsis bs_select cohort_manager caas pi pds modality local_pacs gpms lims bard iuvo cis2 mesh shim
        autolayout lr
    }

    systemContext bcss "Bowel_Screening" {
      include bcss gpms pds pi bowel_obiee fit_middleware rdi iuvo ndrs ndrs cis2 ods notify
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
      include csms cervical_home_testing pds cis2 notify capita_notifications lims ods cervical_home_testing_provider mesh gpms nhsnet dps
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
