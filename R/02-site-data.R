provider_data <- list(
  camh = list(
    provider_tag = "camh",
    location_id = c("CMH"),
    key = "e9ae7abf-1c88-479b-9c1a-2e81a21da988",
    tibble(
      slot_type = c(
        "Patient",           # Healthcare providers
        "CONDITIONS",        # Mental health / substance abuse disorders
        "INDIGENOUS",        # Indigenous (FN, Inuit, Metis)
        "LEADERS",           # Faith leaders
        "CONGREGATE",        # High-risk in congregate settings
        "HOTSPOT"            # 50+ living in a hotspot
      ),
      slot_type_label = c(
        "Healthcare Providers",
        "Mental he"
      )
    )
  ),

  ymca_west = list(
    provider_tag = "mwtoht-ymca",
    location_id = c("WCV"),
    key = "9518d7a7-27c9-49a1-ac49-f523bfcbbfe4",
    slot_type = c(
      "Older",             # 60+
      "Chronic",           # Adult Chronic Home Health Care Recipients
      "OLDER50",           # 50+ living in a hotspot
      "CAREGIVERCHRONIC",  # Essential caregivers for chronic home health care recipients
      "Indigenous",        # Indigenous (FN, Inuit, Metis)
      "PATIENT",           # Essential health care workers
      "LEADERS"            # Faith leaders

    )
  ),

  north_york_general = list(
    provider_tag = "nygh",
    location_id = c(
      "SCV",               # Seneca College
      "NFV",               # North York Family Health Team
      "NCV"                # North York General Hospital
    ),
    key = "fba9f065-ebb8-4412-baaf-73534eb37854",
    slot_type = c(
      "OLDER",             # Eligible Age Groups
      "INDIGENOUS",        # Indigenous (FN, Inuit, Metis)
      "Patient",           # Adult Recipients of Chronic Home Health Care, Community Health Care Workers and Faith Leaders,
      "CHRONIC"            # Adults with HIGH or HIGHEST risk health conditions
    )
  ),

  downtown_east_health_team = list(
    provider_tag = "uht-public",
    location_id = c(
      "RPV",               # Regent Park
      "WCC"                #
    ),
    key = "b6f65518-d5bc-4113-b7ed-ee33f7574929",
    slot_type = c(
      "Communities",       # Communities at greater risk
      "Special",           # Special populations
      "HealthComm",        # Healthcare providers
      "IndigenousAdults"   # Indigenous (FN, Inuit, Metis)
    )
  ),

  unity_health_toronto = list(
    provider_tag = "uht-public",
    location_id = c(
      "SMV",               # St. Michael's
      "SJV"                # St. Joseph's
    ),
    key = "543efe0f-0318-4e53-86d7-2e83ac59bf48",
    slot_type = c(
      "Communities",       # Communities at greater risk
      "Special",           # Special Populations
      "HealthComm",        # Health Care Workers and community providers
      "IndigenousAdults",  # Indigenous Adults
      "High",              # Transplant Recipients and Cancer Patients
      "Caregivers"         # In-home caregivers
    )
  ),

  west_park = list(
    provider_tag = "uht-public",
    location_id = c(
      "WPA",               # West Park Health Centre
      "CPH"                # Community Place Hub
    ),
    key = "e85169bf-1248-4899-8b6a-86258fe976c7",
    slot_type = c(
      "Communities",       # Communities at greater risk
      "Special",           # Special Populations
      "HealthComm",        # Health Care Workers and community providers
      "IndigenousAdults"  # Indigenous Adults
    )
  )

)

# providers using verto:
#  - CAMH
#  - YMCA West End
#  - North York General
#  - Unity Health Toronto


# Providers not using verto:
#  - North Toronto Ontario Health Team / Baycrest
#  - Humber River
#  - Michael Garron
#  - Sunnybrook
#  - Thorncliffe Park Community Hub
