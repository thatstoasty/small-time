# TODO (Mikhail): Time zones are very hacky right now. Eventually, I will try adopting Martin's datetime module in `forge-tools` instead.
comptime UTC = "UTC"
comptime DASH = "-"


fn _is_numeric(c: Byte) -> Bool:
    """Checks if a character is numeric.

    Args:
        c: Character.

    Returns:
        True if the character is numeric, False otherwise.
    """
    return c >= ord("0") and c <= ord("9")


fn from_utc(timestamp: StringSlice) raises -> TimeZone:
    """Creates a timezone from a string.

    Args:
        timestamp: UTC string.

    Returns:
        Timezone.

    Raises:
        Error: If the UTC string is invalid.
    """
    if len(timestamp) == 0:
        raise Error("Received empty UTC string.")

    if timestamp == "utc" or timestamp == UTC or timestamp == "Z":
        return TimeZone.UTC

    var i = 0
    # Skip the UTC prefix.
    if len(timestamp) > 3 and timestamp[0:3] == UTC:
        i = 3

    var sign = -1 if timestamp[i:i+1] == DASH else 1
    if timestamp[i:i+1] == "+" or timestamp[i:i+1] == DASH:
        i += 1

    if len(timestamp) < i + 2 or not _is_numeric(ord(timestamp[i:i+1])) or not _is_numeric(ord(timestamp[i + 1:i + 2])):
        raise Error("Received invalid UTC string format.")
    var hours = atol(timestamp[i : i + 2])
    i += 2

    var minutes: Int
    if len(timestamp) <= i:
        minutes = 0
    elif len(timestamp) == i + 3 and timestamp[i:i+1] == ":":
        minutes = atol(timestamp[i + 1 : i + 3])
    elif len(timestamp) == i + 2 and _is_numeric(ord(timestamp[i:i+1])):
        minutes = atol(timestamp[i : i + 2])
    else:
        raise Error("`timestamp` format is invalid")

    var offset = sign * (hours * 3600 + minutes * 60)
    return TimeZone.from_utc_offset(offset)


@fieldwise_init
struct TimeZone(Copyable, ImplicitlyCopyable, Movable):
    """Time zone representation."""

    var name: String
    """Time zone name."""
    var offset: Int
    """Offset in seconds."""
    comptime ASIA_JAKARTA = Self(name="Asia/Jakarta", offset=25200)
    comptime LIBYA = Self(name="Libya", offset=7200)
    comptime AMERICA_IQALUIT = Self(name="America/Iqaluit", offset=-18000)
    comptime AMERICA_INDIANA_VEVAY = Self(name="America/Indiana/Vevay", offset=-18000)
    comptime ATLANTIC_SOUTH_GEORGIA = Self(name="Atlantic/South_Georgia", offset=-7200)
    comptime AMERICA_CUIABA = Self(name="America/Cuiaba", offset=-14400)
    comptime EUROPE_TALLINN = Self(name="Europe/Tallinn", offset=7200)
    comptime AMERICA_ENSENADA = Self(name="America/Ensenada", offset=-28800)
    comptime AFRICA_ABIDJAN = Self(name="Africa/Abidjan", offset=0)
    comptime PACIFIC_SAIPAN = Self(name="Pacific/Saipan", offset=36000)
    comptime MEXICO_GENERAL = Self(name="Mexico/General", offset=-21600)
    comptime EUROPE_ROME = Self(name="Europe/Rome", offset=3600)
    comptime ASIA_SEOUL = Self(name="Asia/Seoul", offset=32400)
    comptime US_MICHIGAN = Self(name="US/Michigan", offset=-18000)
    comptime AMERICA_NEW_YORK = Self(name="America/New_York", offset=-18000)
    comptime EUROPE_ATHENS = Self(name="Europe/Athens", offset=7200)
    comptime EUROPE_LISBON = Self(name="Europe/Lisbon", offset=0)
    comptime AMERICA_ST_THOMAS = Self(name="America/St_Thomas", offset=-14400)
    comptime EUROPE_MOSCOW = Self(name="Europe/Moscow", offset=10800)
    comptime PACIFIC_EASTER = Self(name="Pacific/Easter", offset=-21600)
    comptime AMERICA_PORTO_ACRE = Self(name="America/Porto_Acre", offset=-18000)
    comptime AMERICA_CRESTON = Self(name="America/Creston", offset=-25200)
    comptime PACIFIC_NORFOLK = Self(name="Pacific/Norfolk", offset=43200)
    comptime AMERICA_ARGENTINA_CORDOBA = Self(name="America/Argentina/Cordoba", offset=-10800)
    comptime AMERICA_ATKA = Self(name="America/Atka", offset=-36000)
    comptime PACIFIC_NIUE = Self(name="Pacific/Niue", offset=-39600)
    comptime ASIA_ULAN_BATOR = Self(name="Asia/Ulan_Bator", offset=28800)
    comptime EUROPE_SIMFEROPOL = Self(name="Europe/Simferopol", offset=10800)
    comptime ASIA_DILI = Self(name="Asia/Dili", offset=32400)
    comptime EUROPE_ZAGREB = Self(name="Europe/Zagreb", offset=3600)
    comptime ANTARCTICA_PALMER = Self(name="Antarctica/Palmer", offset=-10800)
    comptime AMERICA_CAYENNE = Self(name="America/Cayenne", offset=-10800)
    comptime ASIA_TEL_AVIV = Self(name="Asia/Tel_Aviv", offset=7200)
    comptime ASIA_URUMQI = Self(name="Asia/Urumqi", offset=21600)
    comptime ASIA_BEIRUT = Self(name="Asia/Beirut", offset=7200)
    comptime ASIA_KUALA_LUMPUR = Self(name="Asia/Kuala_Lumpur", offset=28800)
    comptime AMERICA_BELEM = Self(name="America/Belem", offset=-10800)
    comptime PACIFIC_HONOLULU = Self(name="Pacific/Honolulu", offset=-36000)
    comptime AMERICA_SANTA_ISABEL = Self(name="America/Santa_Isabel", offset=-28800)
    comptime PACIFIC_KWAJALEIN = Self(name="Pacific/Kwajalein", offset=43200)
    comptime AFRICA_LUANDA = Self(name="Africa/Luanda", offset=3600)
    comptime AMERICA_CHICAGO = Self(name="America/Chicago", offset=-21600)
    comptime ASIA_HARBIN = Self(name="Asia/Harbin", offset=28800)
    comptime EUROPE_PARIS = Self(name="Europe/Paris", offset=3600)
    comptime PACIFIC_WALLIS = Self(name="Pacific/Wallis", offset=43200)
    comptime AMERICA_ARGENTINA_USHUAIA = Self(name="America/Argentina/Ushuaia", offset=-10800)
    comptime AUSTRALIA_ADelaide = Self(name="Australia/Adelaide", offset=37800)
    comptime ASIA_SINGAPORE = Self(name="Asia/Singapore", offset=28800)
    comptime AMERICA_KRALENDIJK = Self(name="America/Kralendijk", offset=-14400)
    comptime AMERICA_MONCTON = Self(name="America/Moncton", offset=-14400)
    comptime AMERICA_ARUBA = Self(name="America/Aruba", offset=-14400)
    comptime AMERICA_NORONHA = Self(name="America/Noronha", offset=-7200)
    comptime ETC_UTC = Self(name="Etc/UTC", offset=0)
    comptime AFRICA_LUSAKA = Self(name="Africa/Lusaka", offset=7200)
    comptime ASIA_TOMSK = Self(name="Asia/Tomsk", offset=25200)
    comptime ASIA_PHNOM_PENH = Self(name="Asia/Phnom_Penh", offset=25200)
    comptime ASIA_SAMARKAND = Self(name="Asia/Samarkand", offset=18000)
    comptime EUROPE_LUXEMBOURG = Self(name="Europe/Luxembourg", offset=3600)
    comptime INDIAN_ANTANANARIVO = Self(name="Indian/Antananarivo", offset=10800)
    comptime ETC_GMT_PLUS_1 = Self(name="Etc/GMT+1", offset=-3600)
    comptime AMERICA_PORTO_VELHO = Self(name="America/Porto_Velho", offset=-14400)
    comptime GB = Self(name="GB", offset=0)
    comptime AMERICA_BARbADOS = Self(name="America/Barbados", offset=-14400)
    comptime ASIA_CHUNGKING = Self(name="Asia/Chungking", offset=28800)
    comptime ASIA_SHANGHAI = Self(name="Asia/Shanghai", offset=28800)
    comptime ETC_GMT_13 = Self(name="Etc/GMT-13", offset=46800)
    comptime AMERICA_INDIANA_INDIANAPOLIS = Self(name="America/Indiana/Indianapolis", offset=-18000)
    comptime AMERICA_INDIANA_VINCENNES = Self(name="America/Indiana/Vincennes", offset=-18000)
    comptime AMERICA_INDIANA_TELL_CITY = Self(name="America/Indiana/Tell_City", offset=-21600)
    comptime PACIFIC_KANTON = Self(name="Pacific/Kanton", offset=46800)
    comptime AMERICA_NASSAU = Self(name="America/Nassau", offset=-18000)
    comptime AMERICA_RIO_BRANCO = Self(name="America/Rio_Branco", offset=-18000)
    comptime GMT_MINUS_0 = Self(name="GMT-0", offset=0)
    comptime AUSTRALIA_TASMANIA = Self(name="Australia/Tasmania", offset=36000)
    comptime PACIFIC_KOSRAE = Self(name="Pacific/Kosrae", offset=39600)
    comptime US_HAWAII = Self(name="US/Hawaii", offset=-36000)
    comptime ASIA_TBILISI = Self(name="Asia/Tbilisi", offset=14400)
    comptime PACIFIC_BOUGAINVILLE = Self(name="Pacific/Bougainville", offset=39600)
    comptime EUROPE_VADUZ = Self(name="Europe/Vaduz", offset=3600)
    comptime ETC_GMT_PLUS_11 = Self(name="Etc/GMT+11", offset=-39600)
    comptime AFRICA_WINDHOEK = Self(name="Africa/Windhoek", offset=7200)
    comptime ATLANTIC_JAN_MAYEN = Self(name="Atlantic/Jan_Mayen", offset=3600)
    comptime AFRICA_NDJAMENA = Self(name="Africa/Ndjamena", offset=3600)
    comptime AMERICA_ADAK = Self(name="America/Adak", offset=-36000)
    comptime ISRAEL = Self(name="Israel", offset=7200)
    comptime US_INDiana_STARKE = Self(name="US/Indiana-Starke", offset=-21600)
    comptime AMERICA_NORTH_DAKOTA_NEW_SALEM = Self(name="America/North_Dakota/New_Salem", offset=-21600)
    comptime PACIFIC_PALAU = Self(name="Pacific/Palau", offset=32400)
    comptime GMT_PLUS_0 = Self(name="GMT+0", offset=0)
    comptime AMERICA_RAINY_RIVER = Self(name="America/Rainy_River", offset=-21600)
    comptime AMERICA_WINNIPEG = Self(name="America/Winnipeg", offset=-21600)
    comptime ETC_GREENWICH = Self(name="Etc/Greenwich", offset=0)
    comptime AMERICA_PANGNIRTUNG = Self(name="America/Pangnirtung", offset=-14400)
    comptime AFRICA_TRIPOLI = Self(name="Africa/Tripoli", offset=7200)
    comptime AMERICA_GUATEMALA = Self(name="America/Guatemala", offset=-21600)
    comptime ASIA_NICOSIA = Self(name="Asia/Nicosia", offset=7200)
    comptime AMERICA_BELIZE = Self(name="America/Belize", offset=-21600)
    comptime AMERICA_RESOLUTE = Self(name="America/Resolute", offset=-21600)
    comptime ASIA_HEBRON = Self(name="Asia/Hebron", offset=7200)
    comptime AMERICA_CARACAS = Self(name="America/Caracas", offset=-14400)
    comptime ASIA_NOVOSIBIRSK = Self(name="Asia/Novosibirsk", offset=25200)
    comptime EUROPE_PODGORICA = Self(name="Europe/Podgorica", offset=3600)
    comptime PRC = Self(name="PRC", offset=28800)
    comptime EUROPE_KALININGRAD = Self(name="Europe/Kaliningrad", offset=7200)
    comptime EUROPE_ZURICH = Self(name="Europe/Zurich", offset=3600)
    comptime AMERICA_ST_BARTHELEMY = Self(name="America/St_Barthelemy", offset=-14400)
    comptime AMERICA_NUUK = Self(name="America/Nuuk", offset=-7200)
    comptime ETC_GMT_PLUS_12 = Self(name="Etc/GMT+12", offset=-43200)
    comptime ASIA_HONG_KONG = Self(name="Asia/Hong_Kong", offset=28800)
    comptime ETC_GMT_MINUS_3 = Self(name="Etc/GMT-3", offset=10800)
    comptime AMERICA_MIQUELON = Self(name="America/Miquelon", offset=-10800)
    comptime EUROPE_VOLGOGRAD = Self(name="Europe/Volgograd", offset=10800)
    comptime EUROPE_MADRID = Self(name="Europe/Madrid", offset=3600)
    comptime AMERICA_MONTERREY = Self(name="America/Monterrey", offset=-21600)
    comptime AMERICA_ANCHORAGE = Self(name="America/Anchorage", offset=-32400)
    comptime AMERICA_ARGENTINA_SAN_LUIS = Self(name="America/Argentina/San_Luis", offset=-10800)
    comptime AMERICA_EIRUNEPE = Self(name="America/Eirunepe", offset=-18000)
    comptime AMERICA_ST_KITTS = Self(name="America/St_Kitts", offset=-14400)
    comptime AMERICA_BAHIA_BANDERAS = Self(name="America/Bahia_Banderas", offset=-21600)
    comptime ETC_GMT_PLUS_2 = Self(name="Etc/GMT+2", offset=-7200)
    comptime ZULU = Self(name="Zulu", offset=0)
    comptime AFRICA_GABORONE = Self(name="Africa/Gaborone", offset=7200)
    comptime ANTARCTICA_MCMURDO = Self(name="Antarctica/McMurdo", offset=46800)
    comptime EUROPE_GUERNSEY = Self(name="Europe/Guernsey", offset=0)
    comptime EUROPE_ANDORRA = Self(name="Europe/Andorra", offset=3600)
    comptime AMERICA_PARAMARIBO = Self(name="America/Paramaribo", offset=-10800)
    comptime AMERICA_FORT_NELSON = Self(name="America/Fort_Nelson", offset=-25200)
    comptime ANTARCTICA_TROLL = Self(name="Antarctica/Troll", offset=0)
    comptime EUROPE_UZHGOROD = Self(name="Europe/Uzhgorod", offset=7200)
    comptime ATLANTIC_CAPE_VERDE = Self(name="Atlantic/Cape_Verde", offset=-3600)
    comptime UCT = Self(name="UCT", offset=0)
    comptime ETC_GMT_MINUS_6 = Self(name="Etc/GMT-6", offset=21600)
    comptime ASIA_SREDNEKOLYMSK = Self(name="Asia/Srednekolymsk", offset=39600)
    comptime ASIA_UJUNG_PANDANG = Self(name="Asia/Ujung_Pandang", offset=28800)
    comptime AMERICA_THUNDER_BAY = Self(name="America/Thunder_Bay", offset=-18000)
    comptime AFRICA_KHARTOUM = Self(name="Africa/Khartoum", offset=7200)
    comptime AFRICA_DOUALA = Self(name="Africa/Douala", offset=3600)
    comptime AMERICA_CAYMAN = Self(name="America/Cayman", offset=-18000)
    comptime BRAZIL_ACRE = Self(name="Brazil/Acre", offset=-18000)
    comptime AMERICA_INDIANA_KNOX = Self(name="America/Indiana/Knox", offset=-21600)
    comptime AUSTRALIA_YANCOWINNA = Self(name="Australia/Yancowinna", offset=34200)
    comptime AMERICA_CHIHUAHUA = Self(name="America/Chihuahua", offset=-25200)
    comptime AMERICA_RECIFE = Self(name="America/Recife", offset=-10800)
    comptime AMERICA_INDIANA_MARENGO = Self(name="America/Indiana/Marengo", offset=-18000)
    comptime ASIA_YANGON = Self(name="Asia/Yangon", offset=23400)
    comptime EUROPE_ASTRAKHAN = Self(name="Europe/Astrakhan", offset=14400)
    comptime ASIA_RANGOON = Self(name="Asia/Rangoon", offset=23400)
    comptime AMERICA_VANCOUVER = Self(name="America/Vancouver", offset=-28800)
    comptime NZ_CHAT = Self(name="NZ-CHAT", offset=49500)
    comptime AMERICA_MONTERRAT = Self(name="America/Montserrat", offset=-14400)
    comptime AMERICA_MERIDA = Self(name="America/Merida", offset=-21600)
    comptime AMERICA_PUERTO_RICO = Self(name="America/Puerto_Rico", offset=-14400)
    comptime AMERICA_MACEIO = Self(name="America/Maceio", offset=-10800)
    comptime AMERICA_PANAMA = Self(name="America/Panama", offset=-18000)
    comptime BRAZIL_EAST = Self(name="Brazil/East", offset=-10800)
    comptime JAPAN = Self(name="Japan", offset=32400)
    comptime AUSTRALIA_VICTORIA = Self(name="Australia/Victoria", offset=36000)
    comptime AMERICA_INDIANA_PETERSBURG = Self(name="America/Indiana/Petersburg", offset=-18000)
    comptime ASIA_DUSHANBE = Self(name="Asia/Dushanbe", offset=18000)
    comptime AFRICA_ASMERA = Self(name="Africa/Asmera", offset=10800)
    comptime ETC_ZULU = Self(name="Etc/Zulu", offset=0)
    comptime EUROPE_MONACO = Self(name="Europe/Monaco", offset=3600)
    comptime ASIA_AMMAN = Self(name="Asia/Amman", offset=7200)
    comptime ASIA_KUWAIT = Self(name="Asia/Kuwait", offset=10800)
    comptime ASIA_SAKHALIN = Self(name="Asia/Sakhalin", offset=39600)
    comptime EUROPE_GIBRALTAR = Self(name="Europe/Gibraltar", offset=3600)
    comptime AMERICA_HAVANA = Self(name="America/Havana", offset=-18000)
    comptime ETC_GMT_PLUS_0 = Self(name="Etc/GMT+0", offset=0)
    comptime ASIA_CHOIBALSAN = Self(name="Asia/Choibalsan", offset=32400)
    comptime ASIA_VIENTIANE = Self(name="Asia/Vientiane", offset=25200)
    comptime AFRICA_MONROVIA = Self(name="Africa/Monrovia", offset=0)
    comptime AFRICA_LAGOS = Self(name="Africa/Lagos", offset=3600)
    comptime AMERICA_ARGENTINA_BUENOS_AIRES = Self(name="America/Argentina/Buenos_Aires", offset=-10800)
    comptime AUSTRALIA_MELBOURNE = Self(name="Australia/Melbourne", offset=36000)
    comptime ETC_GMT_PLUS_6 = Self(name="Etc/GMT+6", offset=-21600)
    comptime PST8PDT = Self(name="PST8PDT", offset=-28800)
    comptime AMERICA_SCORESBYSUND = Self(name="America/Scoresbysund", offset=-3600)
    comptime AUSTRALIA_ACT = Self(name="Australia/ACT", offset=36000)
    comptime AFRICA_BLANTYRE = Self(name="Africa/Blantyre", offset=7200)
    comptime ASIA_SAIGON = Self(name="Asia/Saigon", offset=25200)
    comptime ASIA_CHONGQING = Self(name="Asia/Chongqing", offset=28800)
    comptime GB_EIRE = Self(name="GB-Eire", offset=0)
    comptime US_SAMOA = Self(name="US/Samoa", offset=-39600)
    comptime ARCTIC_LONGYEARBYEN = Self(name="Arctic/Longyearbyen", offset=3600)
    comptime AMERICA_CURACAO = Self(name="America/Curacao", offset=-14400)
    comptime AMERICA_MEXICO_CITY = Self(name="America/Mexico_City", offset=-21600)
    comptime ASIA_KABUL = Self(name="Asia/Kabul", offset=16200)
    comptime AMERICA_INDIANAPOLIS = Self(name="America/Indianapolis", offset=-18000)
    comptime ASIA_MACAO = Self(name="Asia/Macao", offset=28800)
    comptime CANADA_CENTRAL = Self(name="Canada/Central", offset=-21600)
    comptime ASIA_FAMAGUSTA = Self(name="Asia/Famagusta", offset=10800)
    comptime AMERICA_ATIKOKAN = Self(name="America/Atikokan", offset=-18000)
    comptime ASIA_BRUNEI = Self(name="Asia/Brunei", offset=28800)
    comptime ASIA_UST_NERA = Self(name="Asia/Ust-Nera", offset=39600)
    comptime BRAZIL_DE_NORONHA = Self(name="Brazil/DeNoronha", offset=-7200)
    comptime INDIAN_CHAGOS = Self(name="Indian/Chagos", offset=21600)
    comptime ASIA_KATHMANDU = Self(name="Asia/Kathmandu", offset=20700)
    comptime ASIA_TEHRAN = Self(name="Asia/Tehran", offset=12600)
    comptime AFRICA_DAR_ES_SALAAM = Self(name="Africa/Dar_es_Salaam", offset=10800)
    comptime AMERICA_MANAGUA = Self(name="America/Managua", offset=-21600)
    comptime AFRICA_CAIRO = Self(name="Africa/Cairo", offset=7200)
    comptime PACIFIC_NAURU = Self(name="Pacific/Nauru", offset=43200)
    comptime EUROPE_SARATOV = Self(name="Europe/Saratov", offset=14400)
    comptime INDIAN_MALDIVES = Self(name="Indian/Maldives", offset=18000)
    comptime ASIA_MAKASSAR = Self(name="Asia/Makassar", offset=28800)
    comptime AMERICA_SAO_PAULO = Self(name="America/Sao_Paulo", offset=-10800)
    comptime AMERICA_ST_JOHNS = Self(name="America/St_Johns", offset=-12600)
    comptime ETC_GMT_PLUS_9 = Self(name="Etc/GMT+9", offset=-32400)
    comptime ASIA_QYZYLORDA = Self(name="Asia/Qyzylorda", offset=18000)
    comptime AUSTRALIA_NORTH = Self(name="Australia/North", offset=34200)
    comptime AMERICA_MONTEVIDEO = Self(name="America/Montevideo", offset=-10800)
    comptime AUSTRALIA_WEST = Self(name="Australia/West", offset=28800)
    comptime EUROPE_OSLO = Self(name="Europe/Oslo", offset=3600)
    comptime TURKEY = Self(name="Turkey", offset=10800)
    comptime US_CENTRAL = Self(name="US/Central", offset=-21600)
    comptime EUROPE_BERLIN = Self(name="Europe/Berlin", offset=3600)
    comptime EUROPE_BRATISLAVA = Self(name="Europe/Bratislava", offset=3600)
    comptime AMERICA_EL_SALVADOR = Self(name="America/El_Salvador", offset=-21600)
    comptime AFRICA_KAMPALA = Self(name="Africa/Kampala", offset=10800)
    comptime AMERICA_DAWSON = Self(name="America/Dawson", offset=-25200)
    comptime AMERICA_LA_PAZ = Self(name="America/La_Paz", offset=-14400)
    comptime US_ALEUTIAN = Self(name="US/Aleutian", offset=-36000)
    comptime ASIA_KOLKATA = Self(name="Asia/Kolkata", offset=19800)
    comptime ASIA_ORAL = Self(name="Asia/Oral", offset=18000)
    comptime ASIA_OMSK = Self(name="Asia/Omsk", offset=21600)
    comptime AMERICA_SANTIAGO = Self(name="America/Santiago", offset=-10800)
    comptime AMERICA_DETROIT = Self(name="America/Detroit", offset=-18000)
    comptime AMERICA_ANGUILLA = Self(name="America/Anguilla", offset=-14400)
    comptime AMERICA_NOME = Self(name="America/Nome", offset=-32400)
    comptime SINGAPORE = Self(name="Singapore", offset=28800)
    comptime AFRICA_CONAKRY = Self(name="Africa/Conakry", offset=0)
    comptime AFRICA_MAPUTO = Self(name="Africa/Maputo", offset=7200)
    comptime ANTARCTICA_DAVIS = Self(name="Antarctica/Davis", offset=25200)
    comptime ASIA_MANILA = Self(name="Asia/Manila", offset=28800)
    comptime PACIFIC_MAJURO = Self(name="Pacific/Majuro", offset=43200)
    comptime AFRICA_LUBUMBASHI = Self(name="Africa/Lubumbashi", offset=7200)
    comptime PORTUGAL = Self(name="Portugal", offset=0)
    comptime PACIFIC_PORT_MORESBY = Self(name="Pacific/Port_Moresby", offset=36000)
    comptime ETC_GMT_PLUS_3 = Self(name="Etc/GMT+3", offset=-10800)
    comptime CHILE_CONTINENTAL = Self(name="Chile/Continental", offset=-10800)
    comptime GMT = Self(name="GMT", offset=0)
    comptime AMERICA_MARTINIQUE = Self(name="America/Martinique", offset=-14400)
    comptime AFRICA_SAO_TOME = Self(name="Africa/Sao_Tome", offset=0)
    comptime AMERICA_SITKA = Self(name="America/Sitka", offset=-32400)
    comptime ASIA_TAIPEI = Self(name="Asia/Taipei", offset=28800)
    comptime INDIAN_MAYOTTE = Self(name="Indian/Mayotte", offset=10800)
    comptime AMERICA_ARGENTINA_RIO_GALLEGOS = Self(name="America/Argentina/Rio_Gallegos", offset=-10800)
    comptime AMERICA_MENOMINEE = Self(name="America/Menominee", offset=-21600)
    comptime CANADA_PACIFIC = Self(name="Canada/Pacific", offset=-28800)
    comptime MET = Self(name="MET", offset=3600)
    comptime ASIA_THIMBU = Self(name="Asia/Thimbu", offset=21600)
    comptime AMERICA_CAMPO_GRANDE = Self(name="America/Campo_Grande", offset=-14400)
    comptime ASIA_MAGADAN = Self(name="Asia/Magadan", offset=39600)
    comptime AFRICA_CASABLANCA = Self(name="Africa/Casablanca", offset=0)
    comptime AMERICA_GUADELOUPE = Self(name="America/Guadeloupe", offset=-14400)
    comptime ATLANTIC_FAROE = Self(name="Atlantic/Faroe", offset=0)
    comptime ASIA_ANADYR = Self(name="Asia/Anadyr", offset=43200)
    comptime AFRICA_PORTO_NOVO = Self(name="Africa/Porto-Novo", offset=3600)
    comptime AFRICA_BANJUL = Self(name="Africa/Banjul", offset=0)
    comptime INDIAN_COMORO = Self(name="Indian/Comoro", offset=10800)
    comptime AMERICA_YAKUTAT = Self(name="America/Yakutat", offset=-32400)
    comptime PACIFIC_GAMBIER = Self(name="Pacific/Gambier", offset=-32400)
    comptime ASIA_ASHGABAT = Self(name="Asia/Ashgabat", offset=18000)
    comptime ANTARCTICA_DUMONT_DURVILLE = Self(name="Antarctica/DumontDUrville", offset=36000)
    comptime US_EAST_IND = Self(name="US/East-Indiana", offset=-18000)
    comptime ASIA_IRKUTSK = Self(name="Asia/Irkutsk", offset=28800)
    comptime AMERICA_MAZATLAN = Self(name="America/Mazatlan", offset=-25200)
    comptime PACIFIC_APIA = Self(name="Pacific/Apia", offset=46800)
    comptime AMERICA_BOA_VISTA = Self(name="America/Boa_Vista", offset=-14400)
    comptime ETC_GMT = Self(name="Etc/GMT", offset=0)
    comptime AMERICA_GUYANA = Self(name="America/Guyana", offset=-14400)
    comptime AUSTRALIA_CURRIE = Self(name="Australia/Currie", offset=36000)
    comptime EUROPE_ULYANOVSK = Self(name="Europe/Ulyanovsk", offset=14400)
    comptime PACIFIC_FAKAOFO = Self(name="Pacific/Fakaofo", offset=46800)
    comptime AMERICA_NORTH_DAKOTA_BEULAH = Self(name="America/North_Dakota/Beulah", offset=-21600)
    comptime EUROPE_PRAGUE = Self(name="Europe/Prague", offset=3600)
    comptime ASIA_QATAR = Self(name="Asia/Qatar", offset=10800)
    comptime PACIFIC_FUNAFUTI = Self(name="Pacific/Funafuti", offset=43200)
    comptime JAMAICA = Self(name="Jamaica", offset=-18000)
    comptime CANADA_EASTERN = Self(name="Canada/Eastern", offset=-18000)
    comptime PACIFIC_GUAM = Self(name="Pacific/Guam", offset=36000)
    comptime PACIFIC_FIJI = Self(name="Pacific/Fiji", offset=43200)
    comptime AFRICA_KIGALI = Self(name="Africa/Kigali", offset=7200)
    comptime PACIFIC_TONGATAPU = Self(name="Pacific/Tongatapu", offset=46800)
    comptime AMERICA_LIMA = Self(name="America/Lima", offset=-18000)
    comptime ASIA_MUSCAT = Self(name="Asia/Muscat", offset=14400)
    comptime ANTARCTICA_MACQUARIE = Self(name="Antarctica/Macquarie", offset=39600)
    comptime ETC_GMT_MINUS_2 = Self(name="Etc/GMT-2", offset=7200)
    comptime PACIFIC_PITCAIRN = Self(name="Pacific/Pitcairn", offset=-32400)
    comptime CANADA_MOUNTAIN = Self(name="Canada/Mountain", offset=-25200)
    comptime ASIA_YEKATERINBURG = Self(name="Asia/Yekaterinburg", offset=18000)
    comptime PACIFIC_JOHNSTON = Self(name="Pacific/Johnston", offset=-36000)
    comptime EUROPE_VATICAN = Self(name="Europe/Vatican", offset=3600)
    comptime ATLANTIC_BERMUDA = Self(name="Atlantic/Bermuda", offset=-14400)
    comptime ASIA_JERUSALEM = Self(name="Asia/Jerusalem", offset=7200)
    comptime AMERICA_CIUDAD_JUAREZ = Self(name="America/Ciudad_Juarez", offset=-25200)
    comptime PACIFIC_GALAPAGOS = Self(name="Pacific/Galapagos", offset=-21600)
    comptime AMERICA_MONTREAL = Self(name="America/Montreal", offset=-18000)
    comptime AFRICA_NOUAKCHOTT = Self(name="Africa/Nouakchott", offset=0)
    comptime US_ARIZONA = Self(name="US/Arizona", offset=-25200)
    comptime ASIA_KUCHING = Self(name="Asia/Kuching", offset=28800)
    comptime ETC_GMT_PLUS_4 = Self(name="Etc/GMT+4", offset=-14400)
    comptime AUSTRALIA_BRISBANE = Self(name="Australia/Brisbane", offset=36000)
    comptime CANADA_SASKATCHEWAN = Self(name="Canada/Saskatchewan", offset=-21600)
    comptime EUROPE_DUBLIN = Self(name="Europe/Dublin", offset=0)
    comptime ASIA_QOSTANAY = Self(name="Asia/Qostanay", offset=21600)
    comptime AMERICA_EDMONTON = Self(name="America/Edmonton", offset=-25200)
    comptime ATLANTIC_REYKJAVIK = Self(name="Atlantic/Reykjavik", offset=0)
    comptime AMERICA_FORTALEZA = Self(name="America/Fortaleza", offset=-10800)
    comptime PACIFIC_KIRITIMATI = Self(name="Pacific/Kiritimati", offset=50400)
    comptime ETC_UNIVERSAL = Self(name="Etc/Universal", offset=0)
    comptime GMT0 = Self(name="GMT0", offset=0)
    comptime EUROPE_BELFAST = Self(name="Europe/Belfast", offset=0)
    comptime PACIFIC_YAP = Self(name="Pacific/Yap", offset=36000)
    comptime AMERICA_SANTO_DOMINGO = Self(name="America/Santo_Domingo", offset=-14400)
    comptime ICELAND = Self(name="Iceland", offset=0)
    comptime AMERICA_ARAGUAINA = Self(name="America/Araguaina", offset=-10800)
    comptime ASIA_KARACHI = Self(name="Asia/Karachi", offset=18000)
    comptime ETC_GMT_PLUS_7 = Self(name="Etc/GMT+7", offset=-25200)
    comptime AFRICA_BUJUMBURA = Self(name="Africa/Bujumbura", offset=7200)
    comptime AMERICA_DAWSON_CREEK = Self(name="America/Dawson_Creek", offset=-25200)
    comptime EUROPE_ZAPOROZHYE = Self(name="Europe/Zaporozhye", offset=7200)
    comptime ASIA_ULAANBAATAR = Self(name="Asia/Ulaanbaatar", offset=28800)
    comptime PACIFIC_SAMOA = Self(name="Pacific/Samoa", offset=-39600)
    comptime AUSTRALIA_DARWIN = Self(name="Australia/Darwin", offset=34200)
    comptime ETC_GMT0 = Self(name="Etc/GMT0", offset=0)
    comptime PACIFIC_TAHITI = Self(name="Pacific/Tahiti", offset=-36000)
    comptime ETC_GMT_MINUS_8 = Self(name="Etc/GMT-8", offset=28800)
    comptime ATLANTIC_FAEROE = Self(name="Atlantic/Faeroe", offset=0)
    comptime AFRICA_LIBREVILLE = Self(name="Africa/Libreville", offset=3600)
    comptime ASIA_BARNAUL = Self(name="Asia/Barnaul", offset=25200)
    comptime AMERICA_CORAL_HARBOUR = Self(name="America/Coral_Harbour", offset=-18000)
    comptime ANTARCTICA_SYOWA = Self(name="Antarctica/Syowa", offset=10800)
    comptime AMERICA_BUENOS_AIRES = Self(name="America/Buenos_Aires", offset=-10800)
    comptime EUROPE_VIENNA = Self(name="Europe/Vienna", offset=3600)
    comptime AMERICA_FORT_WAYNE = Self(name="America/Fort_Wayne", offset=-18000)
    comptime NZ = Self(name="NZ", offset=43200)
    comptime ATLANTIC_AZORES = Self(name="Atlantic/Azores", offset=-3600)
    comptime AMERICA_COYHAIQUE = Self(name="America/Coyhaique", offset=-10800)
    comptime ASIA_PYONGYANG = Self(name="Asia/Pyongyang", offset=32400)
    comptime ETC_GMT_MINUS_10 = Self(name="Etc/GMT-10", offset=36000)
    comptime MST = Self(name="MST", offset=-25200)
    comptime AMERICA_ARGENTINA_JUJUY = Self(name="America/Argentina/Jujuy", offset=-10800)
    comptime AMERICA_TIJUANA = Self(name="America/Tijuana", offset=-28800)
    comptime PACIFIC_GUADALCANAL = Self(name="Pacific/Guadalcanal", offset=39600)
    comptime EUROPE_STOCKHOLM = Self(name="Europe/Stockholm", offset=3600)
    comptime US_ALASKA = Self(name="US/Alaska", offset=-32400)
    comptime EUROPE_TIRASPOL = Self(name="Europe/Tiraspol", offset=7200)
    comptime EUROPE_SAMARA = Self(name="Europe/Samara", offset=14400)
    comptime ETC_GMT_MINUS_12 = Self(name="Etc/GMT-12", offset=43200)
    comptime KWAJALEIN = Self(name="Kwajalein", offset=43200)
    comptime ASIA_MACAU = Self(name="Asia/Macau", offset=28800)
    comptime PACIFIC_TRUK = Self(name="Pacific/Truk", offset=36000)
    comptime ASIA_BANGKOK = Self(name="Asia/Bangkok", offset=25200)
    comptime AMERICA_ANTIGUA = Self(name="America/Antigua", offset=-14400)
    comptime AFRICA_EL_AAIUN = Self(name="Africa/El_Aaiun", offset=0)
    comptime EUROPE_MARIEHAMN = Self(name="Europe/Mariehamn", offset=7200)
    comptime ASIA_JAYAPURA = Self(name="Asia/Jayapura", offset=32400)
    comptime EUROPE_SAN_MARINO = Self(name="Europe/San_Marino", offset=3600)
    comptime US_PACIFIC = Self(name="US/Pacific", offset=-28800)
    comptime AFRICA_JOHANNESBURG = Self(name="Africa/Johannesburg", offset=7200)
    comptime AUSTRALIA_EUCLA = Self(name="Australia/Eucla", offset=31500)
    comptime AFRICA_NAIROBI = Self(name="Africa/Nairobi", offset=10800)
    comptime ETC_GMT_MINUS_7 = Self(name="Etc/GMT-7", offset=25200)
    comptime AMERICA_INUVIK = Self(name="America/Inuvik", offset=-25200)
    comptime ASIA_TOKYO = Self(name="Asia/Tokyo", offset=32400)
    comptime ASIA_ATYRAU = Self(name="Asia/Atyrau", offset=18000)
    comptime ASIA_KASHGAR = Self(name="Asia/Kashgar", offset=21600)
    comptime W_SU = Self(name="W-SU", offset=10800)
    comptime ASIA_TASHKENT = Self(name="Asia/Tashkent", offset=18000)
    comptime AFRICA_FREETOWN = Self(name="Africa/Freetown", offset=0)
    comptime PACIFIC_PAGO_PAGO = Self(name="Pacific/Pago_Pago", offset=-39600)
    comptime AMERICA_DENVER = Self(name="America/Denver", offset=-25200)
    comptime AUSTRALIA_LHI = Self(name="Australia/LHI", offset=37800)
    comptime PACIFIC_RAROTONGA = Self(name="Pacific/Rarotonga", offset=-36000)
    comptime MST7MDT = Self(name="MST7MDT", offset=-25200)
    comptime PACIFIC_NOUMEA = Self(name="Pacific/Noumea", offset=39600)
    comptime ETC_UCT = Self(name="Etc/UCT", offset=0)
    comptime ETC_GMT_PLUS_10 = Self(name="Etc/GMT+10", offset=-36000)
    comptime ROK = Self(name="ROK", offset=32400)
    comptime PACIFIC_AUCKLAND = Self(name="Pacific/Auckland", offset=43200)
    comptime ASIA_NOVOKUZNETSK = Self(name="Asia/Novokuznetsk", offset=25200)
    comptime AMERICA_HERMOSILLO = Self(name="America/Hermosillo", offset=-25200)
    comptime AMERICA_LOUISVILLE = Self(name="America/Louisville", offset=-18000)
    comptime ASIA_HO_CHI_MINH = Self(name="Asia/Ho_Chi_Minh", offset=25200)
    comptime ASIA_YEREVAN = Self(name="Asia/Yerevan", offset=14400)
    comptime ASIA_YAKUTSK = Self(name="Asia/Yakutsk", offset=32400)
    comptime UNIVERSAL = Self(name="Universal", offset=0)
    comptime AMERICA_TEGUCIGALPA = Self(name="America/Tegucigalpa", offset=-21600)
    comptime MEXICO_BAJANORTE = Self(name="Mexico/BajaNorte", offset=-28800)
    comptime EUROPE_SARAJEVO = Self(name="Europe/Sarajevo", offset=3600)
    comptime AMERICA_ARGENTINA_CATAMARCA = Self(name="America/Argentina/Catamarca", offset=-10800)
    comptime CUBA = Self(name="Cuba", offset=-18000)
    comptime ASIA_KHANDYGA = Self(name="Asia/Khandyga", offset=32400)
    comptime AMERICA_LOWER_PRINCES = Self(name="America/Lower_Princes", offset=-14400)
    comptime AMERICA_BLANC_SABLON = Self(name="America/Blanc-Sablon", offset=-14400)
    comptime AMERICA_BOGOTA = Self(name="America/Bogota", offset=-18000)
    comptime AFRICA_LOME = Self(name="Africa/Lome", offset=0)
    comptime AMERICA_TORONTO = Self(name="America/Toronto", offset=-18000)
    comptime EUROPE_WARSAW = Self(name="Europe/Warsaw", offset=3600)
    comptime AMERICA_YELLOWKNIFE = Self(name="America/Yellowknife", offset=-25200)
    comptime AMERICA_SWIFT_CURRENT = Self(name="America/Swift_Current", offset=-21600)
    comptime EST = Self(name="EST", offset=-18000)
    comptime EUROPE_SOFIA = Self(name="Europe/Sofia", offset=7200)
    comptime AFRICA_CEUTA = Self(name="Africa/Ceuta", offset=3600)
    comptime AMERICA_MARIGOT = Self(name="America/Marigot", offset=-14400)
    comptime AMERICA_DANMARKSHAVN = Self(name="America/Danmarkshavn", offset=0)
    comptime AFRICA_HARARE = Self(name="Africa/Harare", offset=7200)
    comptime UTC = Self(name="UTC", offset=0)
    comptime UTC_PLUS_1 = Self(name="UTC+1", offset=3600)
    comptime UTC_PLUS_2 = Self(name="UTC+2", offset=7200)
    comptime UTC_PLUS_3 = Self(name="UTC+3", offset=10800)
    comptime UTC_PLUS_4 = Self(name="UTC+4", offset=14400)
    comptime UTC_PLUS_5 = Self(name="UTC+5", offset=18000)
    comptime UTC_PLUS_6 = Self(name="UTC+6", offset=21600)
    comptime UTC_PLUS_7 = Self(name="UTC+7", offset=25200)
    comptime UTC_PLUS_8 = Self(name="UTC+8", offset=28800)
    comptime UTC_PLUS_9 = Self(name="UTC+9", offset=32400)
    comptime UTC_PLUS_10 = Self(name="UTC+10", offset=36000)
    comptime UTC_PLUS_11 = Self(name="UTC+11", offset=39600)
    comptime UTC_PLUS_12 = Self(name="UTC+12", offset=43200)
    comptime UTC_MINUS_1 = Self(name="UTC-1", offset=-3600)
    comptime UTC_MINUS_2 = Self(name="UTC-2", offset=-7200)
    comptime UTC_MINUS_3 = Self(name="UTC-3", offset=-10800)
    comptime UTC_MINUS_4 = Self(name="UTC-4", offset=-14400)
    comptime UTC_MINUS_5 = Self(name="UTC-5", offset=-18000)
    comptime UTC_MINUS_6 = Self(name="UTC-6", offset=-21600)
    comptime UTC_MINUS_7 = Self(name="UTC-7", offset=-25200)
    comptime UTC_MINUS_8 = Self(name="UTC-8", offset=-28800)
    comptime UTC_MINUS_9 = Self(name="UTC-9", offset=-32400)
    comptime UTC_MINUS_10 = Self(name="UTC-10", offset=-36000)
    comptime UTC_MINUS_11 = Self(name="UTC-11", offset=-39600)
    comptime UTC_MINUS_12 = Self(name="UTC-12", offset=-43200)
    comptime EST5EDT = Self(name="EST5EDT", offset=-18000)
    comptime PACIFIC_MIDWAY = Self(name="Pacific/Midway", offset=-39600)
    comptime ASIA_ISTANBUL = Self(name="Asia/Istanbul", offset=10800)
    comptime AMERICA_ARGENTINA_COMODRIVADAVIA = Self(name="America/Argentina/ComodRivadavia", offset=-10800)
    comptime ASIA_BAKU = Self(name="Asia/Baku", offset=14400)
    comptime AUSTRALIA_NSW = Self(name="Australia/NSW", offset=36000)
    comptime EUROPE_BUSINGEN = Self(name="Europe/Busingen", offset=3600)
    comptime AMERICA_REGINA = Self(name="America/Regina", offset=-21600)
    comptime AFRICA_BANGUI = Self(name="Africa/Bangui", offset=3600)
    comptime POLAND = Self(name="Poland", offset=3600)
    comptime INDIAN_CHRISTMAS = Self(name="Indian/Christmas", offset=25200)
    comptime AUSTRALIA_QUEENSLAND = Self(name="Australia/Queensland", offset=36000)
    comptime ASIA_BISHKEK = Self(name="Asia/Bishkek", offset=21600)
    comptime ASIA_DUBAI = Self(name="Asia/Dubai", offset=14400)
    comptime AFRICA_MBABANE = Self(name="Africa/Mbabane", offset=7200)
    comptime AMERICA_GRAND_TURK = Self(name="America/Grand_Turk", offset=-18000)
    comptime AMERICA_GLACE_BAY = Self(name="America/Glace_Bay", offset=-14400)
    comptime PACIFIC_ENDERBURY = Self(name="Pacific/Enderbury", offset=46800)
    comptime AFRICA_DAKAR = Self(name="Africa/Dakar", offset=0)
    comptime AFRICA_ALGIERS = Self(name="Africa/Algiers", offset=3600)
    comptime ASIA_DAMASCUS = Self(name="Asia/Damascus", offset=7200)
    comptime AMERICA_RANKIN_INLET = Self(name="America/Rankin_Inlet", offset=-21600)
    comptime EUROPE_BRUSSELS = Self(name="Europe/Brussels", offset=3600)
    comptime ASIA_HOVD = Self(name="Asia/Hovd", offset=25200)
    comptime AUSTRALIA_HOBART = Self(name="Australia/Hobart", offset=39600)
    comptime EUROPE_BUCHAREST = Self(name="Europe/Bucharest", offset=7200)
    comptime ASIA_GAZA = Self(name="Asia/Gaza", offset=7200)
    comptime IRAN = Self(name="Iran", offset=12600)
    comptime AFRICA_DJIBOUTI = Self(name="Africa/Djibouti", offset=10800)
    comptime AMERICA_ROSARIO = Self(name="America/Rosario", offset=-10800)
    comptime EUROPE_BELGRADE = Self(name="Europe/Belgrade", offset=3600)
    comptime ANTARCTICA_ROTHERA = Self(name="Antarctica/Rothera", offset=-10800)
    comptime AFRICA_ADDIS_ABABA = Self(name="Africa/Addis_Ababa", offset=10800)
    comptime ASIA_DACCA = Self(name="Asia/Dacca", offset=21600)
    comptime ASIA_KRASNOYARSK = Self(name="Asia/Krasnoyarsk", offset=25200)
    comptime EUROPE_CHISINAU = Self(name="Europe/Chisinau", offset=7200)
    comptime INDIAN_COCOS = Self(name="Indian/Cocos", offset=23400)
    comptime AMERICA_CAMBRIDGE_BAY = Self(name="America/Cambridge_Bay", offset=-25200)
    comptime ASIA_THIMPHU = Self(name="Asia/Thimphu", offset=21600)
    comptime EUROPE_RIGA = Self(name="Europe/Riga", offset=7200)
    comptime US_MOUNTAIN = Self(name="US/Mountain", offset=-25200)
    comptime EGYPT = Self(name="Egypt", offset=7200)
    comptime AMERICA_ARGENTINA_TUCUMAN = Self(name="America/Argentina/Tucuman", offset=-10800)
    comptime ATLANTIC_ST_HELENA = Self(name="Atlantic/St_Helena", offset=0)
    comptime GREENWICH = Self(name="Greenwich", offset=0)
    comptime ASIA_ASHKHABAD = Self(name="Asia/Ashkhabad", offset=18000)
    comptime EUROPE_NICOSIA = Self(name="Europe/Nicosia", offset=7200)
    comptime ASIA_AQTAU = Self(name="Asia/Aqtau", offset=18000)
    comptime ANTARCTICA_MAWSON = Self(name="Antarctica/Mawson", offset=18000)
    comptime AMERICA_NORTH_DAKOTA_CENTER = Self(name="America/North_Dakota/Center", offset=-21600)
    comptime EET = Self(name="EET", offset=7200)
    comptime ROC = Self(name="ROC", offset=28800)
    comptime AMERICA_MENDOZA = Self(name="America/Mendoza", offset=-10800)
    comptime AMERICA_ST_VINCENT = Self(name="America/St_Vincent", offset=-14400)
    comptime CST6CDT = Self(name="CST6CDT", offset=-21600)
    comptime ASIA_BAHRAIN = Self(name="Asia/Bahrain", offset=10800)
    comptime ASIA_RIYADH = Self(name="Asia/Riyadh", offset=10800)
    comptime PACIFIC_EFATE = Self(name="Pacific/Efate", offset=39600)
    comptime INDIAN_MAURITIUS = Self(name="Indian/Mauritius", offset=14400)
    comptime INDIAN_KERGUELEN = Self(name="Indian/Kerguelen", offset=18000)
    comptime ASIA_COLOMBO = Self(name="Asia/Colombo", offset=19800)
    comptime AFRICA_MASERU = Self(name="Africa/Maseru", offset=7200)
    comptime AMERICA_ASUNCION = Self(name="America/Asuncion", offset=-14400)
    comptime EUROPE_COPENHAGEN = Self(name="Europe/Copenhagen", offset=3600)
    comptime AMERICA_ARGENTINA_SALTA = Self(name="America/Argentina/Salta", offset=-10800)
    comptime AFRICA_MALABO = Self(name="Africa/Malabo", offset=3600)
    comptime AMERICA_MATAMOROS = Self(name="America/Matamoros", offset=-21600)
    comptime AMERICA_ARGENTINA_LA_RIOJA = Self(name="America/Argentina/La_Rioja", offset=-10800)
    comptime AFRICA_ACCRA = Self(name="Africa/Accra", offset=0)
    comptime EIRE = Self(name="Eire", offset=0)
    comptime AMERICA_KENTUCKY_LOUISVILLE = Self(name="America/Kentucky/Louisville", offset=-18000)
    comptime AFRICA_BAMAKO = Self(name="Africa/Bamako", offset=0)
    comptime ETC_GMT_5 = Self(name="Etc/GMT-5", offset=18000)
    comptime PACIFIC_CHATHAM = Self(name="Pacific/Chatham", offset=45900)
    comptime WET = Self(name="WET", offset=0)
    comptime ETC_GMT_PLUS_5 = Self(name="Etc/GMT+5", offset=-18000)
    comptime AFRICA_MOGADISHU = Self(name="Africa/Mogadishu", offset=10800)
    comptime AMERICA_THULE = Self(name="America/Thule", offset=-10800)
    comptime AMERICA_PHOENIX = Self(name="America/Phoenix", offset=-25200)
    comptime AUSTRALIA_LORD_HOWE = Self(name="Australia/Lord_Howe", offset=37800)
    comptime PACIFIC_CHUUK = Self(name="Pacific/Chuuk", offset=36000)
    comptime PACIFIC_MARQUESAS = Self(name="Pacific/Marquesas", offset=-34200)
    comptime PACIFIC_WAKE = Self(name="Pacific/Wake", offset=43200)
    comptime AFRICA_BRAZZAVILLE = Self(name="Africa/Brazzaville", offset=3600)
    comptime AUSTRALIA_BROKEN_HILL = Self(name="Australia/Broken_Hill", offset=34200)
    comptime AUSTRALIA_SOUTH = Self(name="Australia/South", offset=34200)
    comptime AMERICA_KENTUCKY_MONTICELLO = Self(name="America/Kentucky/Monticello", offset=-18000)
    comptime EUROPE_KIEV = Self(name="Europe/Kiev", offset=7200)
    comptime ETC_GMT_9 = Self(name="Etc/GMT-9", offset=32400)
    comptime AUSTRALIA_LINDEMAN = Self(name="Australia/Lindeman", offset=36000)
    comptime AMERICA_METLAKATLA = Self(name="America/Metlakatla", offset=-28800)
    comptime AMERICA_GOOSE_BAY = Self(name="America/Goose_Bay", offset=-14400)
    comptime AMERICA_ST_LUCIA = Self(name="America/St_Lucia", offset=-14400)
    comptime EUROPE_LJUBLJANA = Self(name="Europe/Ljubljana", offset=3600)
    comptime EUROPE_TIRANE = Self(name="Europe/Tirane", offset=3600)
    comptime AMERICA_SANTAREM = Self(name="America/Santarem", offset=-10800)
    comptime ATLANTIC_CANARY = Self(name="Atlantic/Canary", offset=0)
    comptime AMERICA_GRENADA = Self(name="America/Grenada", offset=-14400)
    comptime AMERICA_SHIPROCK = Self(name="America/Shiprock", offset=-25200)
    comptime EUROPE_SKOPJE = Self(name="Europe/Skopje", offset=3600)
    comptime ETC_GMT_PLUS_8 = Self(name="Etc/GMT+8", offset=-28800)
    comptime ASIA_BAGHDAD = Self(name="Asia/Baghdad", offset=10800)
    comptime AUSTRALIA_SYDNEY = Self(name="Australia/Sydney", offset=36000)
    comptime EUROPE_ISTANBUL = Self(name="Europe/Istanbul", offset=10800)
    comptime AMERICA_DOMINICA = Self(name="America/Dominica", offset=-14400)
    comptime AMERICA_NIPIGON = Self(name="America/Nipigon", offset=-18000)
    comptime ASIA_CALCUTTA = Self(name="Asia/Calcutta", offset=19800)
    comptime ETC_GMT_0 = Self(name="Etc/GMT-0", offset=0)
    comptime ANTARCTICA_CASEY = Self(name="Antarctica/Casey", offset=28800)
    comptime ASIA_VLADIVOSTOK = Self(name="Asia/Vladivostok", offset=36000)
    comptime AMERICA_GODTHAB = Self(name="America/Godthab", offset=-10800)
    comptime ASIA_AQTUBE = Self(name="Asia/Aqtube", offset=18000)
    comptime EUROPE_KIROV = Self(name="Europe/Kirov", offset=10800)
    comptime ASIA_ADEN = Self(name="Asia/Aden", offset=10800)
    comptime EUROPE_ISLE_OF_MAN = Self(name="Europe/Isle_of_Man", offset=0)

    fn __init__(out self, name: StringLiteral, offset: Int):
        """Initializes a new timezone.

        Args:
            name: Time zone name.
            offset: UTC offset in seconds.
        """
        self.name = String(name)
        self.offset = offset

    fn format(self, separator: String = ":") -> String:
        """Formats the timezone.

        Args:
            separator: Separator between hours and minutes.

        Returns:
            Formatted timezone.
        """
        var sign: String
        var offset_abs: Int
        if self.offset < 0:
            sign = "-"
            offset_abs = -self.offset
        else:
            sign = "+"
            offset_abs = self.offset
        var hours = String(offset_abs // 3600).rjust(2, "0")
        var minutes = String(offset_abs % 3600).rjust(2, "0")
        return String(sign, hours, separator, minutes)

    @staticmethod
    fn from_utc_offset(offset: Int) raises -> Self:
        """Creates a new timezone from its UTC offset.

        Args:
            offset: UTC offset in seconds.

        Returns:
            A new timezone instance.

        Raises:
            Error: If an unsupported UTC offset is provided.
        """
        if offset == 0:
            return Self.UTC
        elif offset == 3600:
            return Self.UTC_PLUS_1
        elif offset == 7200:
            return Self.UTC_PLUS_2
        elif offset == 10800:
            return Self.UTC_PLUS_3
        elif offset == 14400:
            return Self.UTC_PLUS_4
        elif offset == 18000:
            return Self.UTC_PLUS_5
        elif offset == 21600:
            return Self.UTC_PLUS_6
        elif offset == 25200:
            return Self.UTC_PLUS_7
        elif offset == 28800:
            return Self.UTC_PLUS_8
        elif offset == 32400:
            return Self.UTC_PLUS_9
        elif offset == 36000:
            return Self.UTC_PLUS_10
        elif offset == 39600:
            return Self.UTC_PLUS_11
        elif offset == 43200:
            return Self.UTC_PLUS_12
        elif offset == -3600:
            return Self.UTC_MINUS_1
        elif offset == -7200:
            return Self.UTC_MINUS_2
        elif offset == -10800:
            return Self.UTC_MINUS_3
        elif offset == -14400:
            return Self.UTC_MINUS_4
        elif offset == -18000:
            return Self.UTC_MINUS_5
        elif offset == -21600:
            return Self.UTC_MINUS_6
        elif offset == -25200:
            return Self.UTC_MINUS_7
        elif offset == -28800:
            return Self.UTC_MINUS_8
        elif offset == -32400:
            return Self.UTC_MINUS_9
        elif offset == -36000:
            return Self.UTC_MINUS_10
        elif offset == -39600:
            return Self.UTC_MINUS_11
        elif offset == -43200:
            return Self.UTC_MINUS_12

        raise Error("Unsupported UTC offset, must be a multiple of 3600 seconds. +-12 hours are supported.")


comptime TIMEZONE_MAP: Dict[String, TimeZone] = {
    "Asia/Jakarta": TimeZone.ASIA_JAKARTA,
    "Libya": TimeZone.LIBYA,
    "America/Iqaluit": TimeZone.AMERICA_IQALUIT,
    "America/Indiana/Vevay": TimeZone.AMERICA_INDIANA_VEVAY,
    "Atlantic/South_Georgia": TimeZone.ATLANTIC_SOUTH_GEORGIA,
    "America/Cuiaba": TimeZone.AMERICA_CUIABA,
    "Europe/Tallinn": TimeZone.EUROPE_TALLINN,
    "America/Ensenada": TimeZone.AMERICA_ENSENADA,
    "Africa/Abidjan": TimeZone.AFRICA_ABIDJAN,
    "Pacific/Saipan": TimeZone.PACIFIC_SAIPAN,
    "Mexico/General": TimeZone.MEXICO_GENERAL,
    "Europe/Rome": TimeZone.EUROPE_ROME,
    "Asia/Seoul": TimeZone.ASIA_SEOUL,
    "US/Michigan": TimeZone.US_MICHIGAN,
    "America/New_York": TimeZone.AMERICA_NEW_YORK,
    "Europe/Athens": TimeZone.EUROPE_ATHENS,
    "Europe/Lisbon": TimeZone.EUROPE_LISBON,
    "America/St_Thomas": TimeZone.AMERICA_ST_THOMAS,
    "Europe/Moscow": TimeZone.EUROPE_MOSCOW,
    "Pacific/Easter": TimeZone.PACIFIC_EASTER,
    "America/Porto_Acre": TimeZone.AMERICA_PORTO_ACRE,
    "America/Creston": TimeZone.AMERICA_CRESTON,
    "Pacific/Norfolk": TimeZone.PACIFIC_NORFOLK,
    "America/Argentina/Cordoba": TimeZone.AMERICA_ARGENTINA_CORDOBA,
    "America/Atka": TimeZone.AMERICA_ATKA,
    "Pacific/Niue": TimeZone.PACIFIC_NIUE,
    "Asia/Ulan_Bator": TimeZone.ASIA_ULAN_BATOR,
    "Europe/Simferopol": TimeZone.EUROPE_SIMFEROPOL,
    "Asia/Dili": TimeZone.ASIA_DILI,
    "Europe/Zagreb": TimeZone.EUROPE_ZAGREB,
    "Antarctica/Palmer": TimeZone.ANTARCTICA_PALMER,
    "America/Cayenne": TimeZone.AMERICA_CAYENNE,
    "Asia/Tel_Aviv": TimeZone.ASIA_TEL_AVIV,
    "Asia/Urumqi": TimeZone.ASIA_URUMQI,
    "Asia/Beirut": TimeZone.ASIA_BEIRUT,
    "Asia/Kuala_Lumpur": TimeZone.ASIA_KUALA_LUMPUR,
    "America/Belem": TimeZone.AMERICA_BELEM,
    "Pacific/Honolulu": TimeZone.PACIFIC_HONOLULU,
    "America/Santa_Isabel": TimeZone.AMERICA_SANTA_ISABEL,
    "Pacific/Kwajalein": TimeZone.PACIFIC_KWAJALEIN,
    "Africa/Luanda": TimeZone.AFRICA_LUANDA,
    "America/Chicago": TimeZone.AMERICA_CHICAGO,
    "Asia/Harbin": TimeZone.ASIA_HARBIN,
    "Europe/Paris": TimeZone.EUROPE_PARIS,
    "Pacific/Wallis": TimeZone.PACIFIC_WALLIS,
    "America/Argentina/Ushuaia": TimeZone.AMERICA_ARGENTINA_USHUAIA,
    "Australia/Adelaide": TimeZone.AUSTRALIA_ADelaide,
    "Asia/Singapore": TimeZone.ASIA_SINGAPORE,
    "America/Kralendijk": TimeZone.AMERICA_KRALENDIJK,
    "America/Moncton": TimeZone.AMERICA_MONCTON,
    "America/Aruba": TimeZone.AMERICA_ARUBA,
    "America/Noronha": TimeZone.AMERICA_NORONHA,
    "Etc/UTC": TimeZone.ETC_UTC,
    "Africa/Lusaka": TimeZone.AFRICA_LUSAKA,
    "Asia/Tomsk": TimeZone.ASIA_TOMSK,
    "Asia/Phnom_Penh": TimeZone.ASIA_PHNOM_PENH,
    "Asia/Samarkand": TimeZone.ASIA_SAMARKAND,
    "Europe/Luxembourg": TimeZone.EUROPE_LUXEMBOURG,
    "Indian/Antananarivo": TimeZone.INDIAN_ANTANANARIVO,
    "Etc/GMT+1": TimeZone.ETC_GMT_PLUS_1,
    "America/Porto_Velho": TimeZone.AMERICA_PORTO_VELHO,
    "GB": TimeZone.GB,
    "America/Barbados": TimeZone.AMERICA_BARbADOS,
    "Asia/Chungking": TimeZone.ASIA_CHUNGKING,
    "Asia/Shanghai": TimeZone.ASIA_SHANGHAI,
    "Etc/GMT-13": TimeZone.ETC_GMT_13,
    "America/Indiana/Indianapolis": TimeZone.AMERICA_INDIANA_INDIANAPOLIS,
    # "America/Jamaica": TimeZone.AMERICA_JAMAICA,
    # "Canada/Newfoundland": TimeZone.CANADA_NEWFOUNDLAND,
    # "America/Cordoba": TimeZone.AMERICA_CORDOBA,
    # "Africa/Niamey": TimeZone.AFRICA_NIAMEY,
    # "America/Halifax": TimeZone.AMERICA_HALIFAX,
    # "Antarctica/South_Pole": TimeZone.ANTARCTICA_SOUTH_POLE,
    # "Africa/Ouagadougou": TimeZone.AFRICA_OUAGADOUGOU,
    # "CET": TimeZone.CET,
    # "America/Argentina/San_Juan": TimeZone.AMERICA_ARGENTINA_SAN_JUAN,
    # "Asia/Almaty": TimeZone.ASIA_ALMATY,
    # "Antarctica/Vostok": TimeZone.ANTARCTICA_VOSTOK,
    # "Canada/Atlantic": TimeZone.CANADA_ATLANTIC,
    # "Europe/Amsterdam": TimeZone.EUROPE_AMSTERDAM,
    # "America/Costa_Rica": TimeZone.AMERICA_COSTA_RICA,
    # "America/Knox_IN": TimeZone.AMERICA_KNOX_IN,
    # "Asia/Pontianak": TimeZone.ASIA_PONTIANAK,
    # "America/Punta_Arenas": TimeZone.AMERICA_PUNTA_ARENAS,
    # "Indian/Mahe": TimeZone.INDIAN_MAHE,
    # "Africa/Timbuktu": TimeZone.AFRICA_TIMBUKTU,
    # "Atlantic/Madeira": TimeZone.ATLANTIC_MADEIRA,
    # "Chile/EasterIsland": TimeZone.CHILE_EASTERISLAND,
    # "Atlantic/Stanley": TimeZone.ATLANTIC_STANLEY,
    # "America/Cancun": TimeZone.AMERICA_CANCUN,
    # "Europe/Minsk": TimeZone.EUROPE_MINSK,
    # "US/Eastern": TimeZone.US_EASTERN,
    # "HST": TimeZone.HST,
    # "America/Boise": TimeZone.AMERICA_BOISE,
    # "Brazil/West": TimeZone.BRAZIL_WEST,
    # "America/Catamarca": TimeZone.AMERICA_CATAMARCA,
    # "America/Port_of_Spain": TimeZone.AMERICA_PORT_OF_SPAIN,
    # "Asia/Katmandu": TimeZone.ASIA_KATMANDU,
    # "Etc/GMT-14": TimeZone.ETC_GMT_MINUS_14,
    # "America/Guayaquil": TimeZone.AMERICA_GUAYAQUIL,
    # "Australia/Canberra": TimeZone.AUSTRALIA_CANBERRA,
    # "America/Ojinaga": TimeZone.AMERICA_OJINAGA,
    # "Europe/Kyiv": TimeZone.EUROPE_KYIV,
    # "Africa/Kinshasa": TimeZone.AFRICA_KINSHASA,
    # "Pacific/Pohnpei": TimeZone.PACIFIC_POHNPEI,
    # "America/Indiana/Winamac": TimeZone.AMERICA_INDIANA_WINAMAC,
    # "Etc/GMT-11": TimeZone.ETC_GMT_MINUS_11,
    # "Asia/Dhaka": TimeZone.ASIA_DHAKA,
    # "Australia/Perth": TimeZone.AUSTRALIA_PERTH,
    # "America/Whitehorse": TimeZone.AMERICA_WHITEHORSE,
    # "Indian/Reunion": TimeZone.INDIAN_REUNION,
    # "Europe/London": TimeZone.EUROPE_LONDON,
    # "Navajo": TimeZone.NAVAJO,
    # "America/Manaus": TimeZone.AMERICA_MANAUS,
    # "Asia/Chita": TimeZone.ASIA_CHITA,
    # "Hongkong": TimeZone.HONGKONG,
    # "Africa/Bissau": TimeZone.AFRICA_BISSAU,
    # "America/Tortola": TimeZone.AMERICA_TORTOLA,
    # "America/Juneau": TimeZone.AMERICA_JUNEAU,
    # "Europe/Malta": TimeZone.EUROPE_MALTA,
    # "Pacific/Ponape": TimeZone.PACIFIC_PONAPE,
    # "Africa/Asmara": TimeZone.AFRICA_ASMARA,
    # "Asia/Kamchatka": TimeZone.ASIA_KAMCHATKA,
    # "Europe/Helsinki": TimeZone.EUROPE_HELSINKI,
    # "America/Los_Angeles": TimeZone.AMERICA_LOS_ANGELES,
    # "Etc/GMT-4": TimeZone.ETC_GMT_MINUS_4,
    # "America/Bahia": TimeZone.AMERICA_BAHIA,
    # "America/Port-au-Prince": TimeZone.AMERICA_PORT_AU_PRINCE,
    # "Europe/Vilnius": TimeZone.EUROPE_VILNIUS,
    # "Etc/GMT-1": TimeZone.ETC_GMT_MINUS_1,
    # "Europe/Jersey": TimeZone.EUROPE_JERSEY,
    # "Africa/Tunis": TimeZone.AFRICA_TUNIS,
    # "Mexico/BajaSur": TimeZone.MEXICO_BAJASUR,
    # "Pacific/Tarawa": TimeZone.PACIFIC_TARAWA,
    # "Canada/Yukon": TimeZone.CANADA_YUKON,
    # "America/Virgin": TimeZone.AMERICA_VIRGIN,
    # "Europe/Budapest": TimeZone.EUROPE_BUDAPEST,
    # "America/Jujuy": TimeZone.AMERICA_JUJUY,
    # "Africa/Juba": TimeZone.AFRICA_JUBA,
    "America/Indiana/Tell_City": TimeZone.AMERICA_INDIANA_TELL_CITY,
    "Pacific/Kanton": TimeZone.PACIFIC_KANTON,
    "America/Nassau": TimeZone.AMERICA_NASSAU,
    "America/Rio_Branco": TimeZone.AMERICA_RIO_BRANCO,
    "GMT-0": TimeZone.GMT_MINUS_0,
    "Australia/Tasmania": TimeZone.AUSTRALIA_TASMANIA,
    "Pacific/Kosrae": TimeZone.PACIFIC_KOSRAE,
    "US/Hawaii": TimeZone.US_HAWAII,
    "Asia/Tbilisi": TimeZone.ASIA_TBILISI,
    "Pacific/Bougainville": TimeZone.PACIFIC_BOUGAINVILLE,
    "Europe/Vaduz": TimeZone.EUROPE_VADUZ,
    "Etc/GMT+11": TimeZone.ETC_GMT_PLUS_11,
    "Africa/Windhoek": TimeZone.AFRICA_WINDHOEK,
    "Atlantic/Jan_Mayen": TimeZone.ATLANTIC_JAN_MAYEN,
    "Africa/Ndjamena": TimeZone.AFRICA_NDJAMENA,
    "America/Adak": TimeZone.AMERICA_ADAK,
    "Israel": TimeZone.ISRAEL,
    "US/Indiana-Starke": TimeZone.US_INDiana_STARKE,
    "America/North_Dakota/New_Salem": TimeZone.AMERICA_NORTH_DAKOTA_NEW_SALEM,
    "Pacific/Palau": TimeZone.PACIFIC_PALAU,
    "GMT+0": TimeZone.GMT_PLUS_0,
    "America/Rainy_River": TimeZone.AMERICA_RAINY_RIVER,
    "America/Winnipeg": TimeZone.AMERICA_WINNIPEG,
    "Etc/Greenwich": TimeZone.ETC_GREENWICH,
    "America/Pangnirtung": TimeZone.AMERICA_PANGNIRTUNG,
    "Africa/Tripoli": TimeZone.AFRICA_TRIPOLI,
    "America/Guatemala": TimeZone.AMERICA_GUATEMALA,
    "Asia/Nicosia": TimeZone.ASIA_NICOSIA,
    "America/Belize": TimeZone.AMERICA_BELIZE,
    "America/Resolute": TimeZone.AMERICA_RESOLUTE,
    "Asia/Hebron": TimeZone.ASIA_HEBRON,
    "America/Caracas": TimeZone.AMERICA_CARACAS,
    "Asia/Novosibirsk": TimeZone.ASIA_NOVOSIBIRSK,
    "Europe/Podgorica": TimeZone.EUROPE_PODGORICA,
    "PRC": TimeZone.PRC,
    "Europe/Kaliningrad": TimeZone.EUROPE_KALININGRAD,
    "Europe/Zurich": TimeZone.EUROPE_ZURICH,
    "America/St_Barthelemy": TimeZone.AMERICA_ST_BARTHELEMY,
    "America/Nuuk": TimeZone.AMERICA_NUUK,
    "Etc/GMT+12": TimeZone.ETC_GMT_PLUS_12,
    "Asia/Hong_Kong": TimeZone.ASIA_HONG_KONG,
    "Etc/GMT-3": TimeZone.ETC_GMT_MINUS_3,
    "America/Miquelon": TimeZone.AMERICA_MIQUELON,
    "Europe/Volgograd": TimeZone.EUROPE_VOLGOGRAD,
    "Europe/Madrid": TimeZone.EUROPE_MADRID,
    "America/Monterrey": TimeZone.AMERICA_MONTERREY,
    "America/Anchorage": TimeZone.AMERICA_ANCHORAGE,
    "America/Argentina/San_Luis": TimeZone.AMERICA_ARGENTINA_SAN_LUIS,
    "America/Eirunepe": TimeZone.AMERICA_EIRUNEPE,
    "America/St_Kitts": TimeZone.AMERICA_ST_KITTS,
    "America/Bahia_Banderas": TimeZone.AMERICA_BAHIA_BANDERAS,
    "Etc/GMT+2": TimeZone.ETC_GMT_PLUS_2,
    "Zulu": TimeZone.ZULU,
    "Africa/Gaborone": TimeZone.AFRICA_GABORONE,
    "Antarctica/McMurdo": TimeZone.ANTARCTICA_MCMURDO,
    "Europe/Guernsey": TimeZone.EUROPE_GUERNSEY,
    "Europe/Andorra": TimeZone.EUROPE_ANDORRA,
    "America/Paramaribo": TimeZone.AMERICA_PARAMARIBO,
    "America/Fort_Nelson": TimeZone.AMERICA_FORT_NELSON,
    "Antarctica/Troll": TimeZone.ANTARCTICA_TROLL,
    "Europe/Uzhgorod": TimeZone.EUROPE_UZHGOROD,
    "Atlantic/Cape_Verde": TimeZone.ATLANTIC_CAPE_VERDE,
    "UCT": TimeZone.UCT,
    "Etc/GMT-6": TimeZone.ETC_GMT_MINUS_6,
    "Asia/Srednekolymsk": TimeZone.ASIA_SREDNEKOLYMSK,
    "Asia/Ujung_Pandang": TimeZone.ASIA_UJUNG_PANDANG,
    "America/Thunder_Bay": TimeZone.AMERICA_THUNDER_BAY,
    "Africa/Khartoum": TimeZone.AFRICA_KHARTOUM,
    "Africa/Douala": TimeZone.AFRICA_DOUALA,
    "America/Cayman": TimeZone.AMERICA_CAYMAN,
    "Brazil/Acre": TimeZone.BRAZIL_ACRE,
    "America/Indiana/Knox": TimeZone.AMERICA_INDIANA_KNOX,
    "Australia/Yancowinna": TimeZone.AUSTRALIA_YANCOWINNA,
    "America/Chihuahua": TimeZone.AMERICA_CHIHUAHUA,
    "America/Recife": TimeZone.AMERICA_RECIFE,
    "America/Indiana/Marengo": TimeZone.AMERICA_INDIANA_MARENGO,
    "Asia/Yangon": TimeZone.ASIA_YANGON,
    "Europe/Astrakhan": TimeZone.EUROPE_ASTRAKHAN,
    "Asia/Rangoon": TimeZone.ASIA_RANGOON,
    "America/Vancouver": TimeZone.AMERICA_VANCOUVER,
    "NZ-CHAT": TimeZone.NZ_CHAT,
    "America/Montserrat": TimeZone.AMERICA_MONTERRAT,
    "America/Merida": TimeZone.AMERICA_MERIDA,
    "America/Puerto_Rico": TimeZone.AMERICA_PUERTO_RICO,
    "America/Maceio": TimeZone.AMERICA_MACEIO,
    "America/Panama": TimeZone.AMERICA_PANAMA,
    "Brazil/East": TimeZone.BRAZIL_EAST,
    "Japan": TimeZone.JAPAN,
    "Australia/Victoria": TimeZone.AUSTRALIA_VICTORIA,
    "America/Indiana/Petersburg": TimeZone.AMERICA_INDIANA_PETERSBURG,
    "Asia/Dushanbe": TimeZone.ASIA_DUSHANBE,
    "Africa/Asmera": TimeZone.AFRICA_ASMERA,
    "Etc/Zulu": TimeZone.ETC_ZULU,
    "Europe/Monaco": TimeZone.EUROPE_MONACO,
    "Asia/Amman": TimeZone.ASIA_AMMAN,
    "Asia/Kuwait": TimeZone.ASIA_KUWAIT,
    "Asia/Sakhalin": TimeZone.ASIA_SAKHALIN,
    "Europe/Gibraltar": TimeZone.EUROPE_GIBRALTAR,
    "America/Havana": TimeZone.AMERICA_HAVANA,
    "Etc/GMT+0": TimeZone.ETC_GMT_PLUS_0,
    "Asia/Choibalsan": TimeZone.ASIA_CHOIBALSAN,
    "Asia/Vientiane": TimeZone.ASIA_VIENTIANE,
    "Africa/Monrovia": TimeZone.AFRICA_MONROVIA,
    "Africa/Lagos": TimeZone.AFRICA_LAGOS,
    "America/Argentina/Buenos_Aires": TimeZone.AMERICA_ARGENTINA_BUENOS_AIRES,
    "Australia/Melbourne": TimeZone.AUSTRALIA_MELBOURNE,
    "Etc/GMT+6": TimeZone.ETC_GMT_PLUS_6,
    "PST8PDT": TimeZone.PST8PDT,
    "America/Scoresbysund": TimeZone.AMERICA_SCORESBYSUND,
    "Australia/ACT": TimeZone.AUSTRALIA_ACT,
    "Africa/Blantyre": TimeZone.AFRICA_BLANTYRE,
    "Asia/Saigon": TimeZone.ASIA_SAIGON,
    "Asia/Chongqing": TimeZone.ASIA_CHONGQING,
    "GB-Eire": TimeZone.GB_EIRE,
    "US/Samoa": TimeZone.US_SAMOA,
    "Arctic/Longyearbyen": TimeZone.ARCTIC_LONGYEARBYEN,
    "America/Curacao": TimeZone.AMERICA_CURACAO,
    "America/Mexico_City": TimeZone.AMERICA_MEXICO_CITY,
    "Asia/Kabul": TimeZone.ASIA_KABUL,
    "America/Indianapolis": TimeZone.AMERICA_INDIANAPOLIS,
    "Asia/Macao": TimeZone.ASIA_MACAO,
    "Canada/Central": TimeZone.CANADA_CENTRAL,
    "Asia/Famagusta": TimeZone.ASIA_FAMAGUSTA,
    "America/Atikokan": TimeZone.AMERICA_ATIKOKAN,
    "Asia/Brunei": TimeZone.ASIA_BRUNEI,
    "Asia/Ust-Nera": TimeZone.ASIA_UST_NERA,
    "Brazil/DeNoronha": TimeZone.BRAZIL_DE_NORONHA,
    "Indian/Chagos": TimeZone.INDIAN_CHAGOS,
    "Asia/Kathmandu": TimeZone.ASIA_KATHMANDU,
    "Asia/Tehran": TimeZone.ASIA_TEHRAN,
    "Africa/Dar_es_Salaam": TimeZone.AFRICA_DAR_ES_SALAAM,
    "America/Managua": TimeZone.AMERICA_MANAGUA,
    "Africa/Cairo": TimeZone.AFRICA_CAIRO,
    "Pacific/Nauru": TimeZone.PACIFIC_NAURU,
    "Europe/Saratov": TimeZone.EUROPE_SARATOV,
    "Indian/Maldives": TimeZone.INDIAN_MALDIVES,
    "Asia/Makassar": TimeZone.ASIA_MAKASSAR,
    "America/Sao_Paulo": TimeZone.AMERICA_SAO_PAULO,
    "America/St_Johns": TimeZone.AMERICA_ST_JOHNS,
    "Etc/GMT+9": TimeZone.ETC_GMT_PLUS_9,
    "Asia/Qyzylorda": TimeZone.ASIA_QYZYLORDA,
    "Australia/North": TimeZone.AUSTRALIA_NORTH,
    "America/Montevideo": TimeZone.AMERICA_MONTEVIDEO,
    "Australia/West": TimeZone.AUSTRALIA_WEST,
    "Europe/Oslo": TimeZone.EUROPE_OSLO,
    "Turkey": TimeZone.TURKEY,
    "US/Central": TimeZone.US_CENTRAL,
    "Europe/Berlin": TimeZone.EUROPE_BERLIN,
    "Europe/Bratislava": TimeZone.EUROPE_BRATISLAVA,
    "America/El_Salvador": TimeZone.AMERICA_EL_SALVADOR,
    "Africa/Kampala": TimeZone.AFRICA_KAMPALA,
    "America/Dawson": TimeZone.AMERICA_DAWSON,
    "America/La_Paz": TimeZone.AMERICA_LA_PAZ,
    "US/Aleutian": TimeZone.US_ALEUTIAN,
    "Asia/Kolkata": TimeZone.ASIA_KOLKATA,
    "Asia/Oral": TimeZone.ASIA_ORAL,
    "Asia/Omsk": TimeZone.ASIA_OMSK,
    "America/Santiago": TimeZone.AMERICA_SANTIAGO,
    "America/Detroit": TimeZone.AMERICA_DETROIT,
    "America/Anguilla": TimeZone.AMERICA_ANGUILLA,
    "America/Nome": TimeZone.AMERICA_NOME,
    "Singapore": TimeZone.SINGAPORE,
    "Africa/Conakry": TimeZone.AFRICA_CONAKRY,
    "Africa/Maputo": TimeZone.AFRICA_MAPUTO,
    "Antarctica/Davis": TimeZone.ANTARCTICA_DAVIS,
    "Asia/Manila": TimeZone.ASIA_MANILA,
    "Pacific/Majuro": TimeZone.PACIFIC_MAJURO,
    "Africa/Lubumbashi": TimeZone.AFRICA_LUBUMBASHI,
    "Portugal": TimeZone.PORTUGAL,
    "Pacific/Port_Moresby": TimeZone.PACIFIC_PORT_MORESBY,
    "Etc/GMT+3": TimeZone.ETC_GMT_PLUS_3,
    "Chile/Continental": TimeZone.CHILE_CONTINENTAL,
    "GMT": TimeZone.GMT,
    "America/Martinique": TimeZone.AMERICA_MARTINIQUE,
    "Africa/Sao_Tome": TimeZone.AFRICA_SAO_TOME,
    "America/Sitka": TimeZone.AMERICA_SITKA,
    "Asia/Taipei": TimeZone.ASIA_TAIPEI,
    "Indian/Mayotte": TimeZone.INDIAN_MAYOTTE,
    "America/Argentina/Rio_Gallegos": TimeZone.AMERICA_ARGENTINA_RIO_GALLEGOS,
    "America/Menominee": TimeZone.AMERICA_MENOMINEE,
    "Canada/Pacific": TimeZone.CANADA_PACIFIC,
    "MET": TimeZone.MET,
    "Asia/Thimbu": TimeZone.ASIA_THIMBU,
    "America/Campo_Grande": TimeZone.AMERICA_CAMPO_GRANDE,
    "Asia/Magadan": TimeZone.ASIA_MAGADAN,
    "Africa/Casablanca": TimeZone.AFRICA_CASABLANCA,
    "America/Guadeloupe": TimeZone.AMERICA_GUADELOUPE,
    "Atlantic/Faroe": TimeZone.ATLANTIC_FAROE,
    "Asia/Anadyr": TimeZone.ASIA_ANADYR,
    "Africa/Porto-Novo": TimeZone.AFRICA_PORTO_NOVO,
    "Africa/Banjul": TimeZone.AFRICA_BANJUL,
    "Indian/Comoro": TimeZone.INDIAN_COMORO,
    "America/Yakutat": TimeZone.AMERICA_YAKUTAT,
    "Pacific/Gambier": TimeZone.PACIFIC_GAMBIER,
    "Asia/Ashgabat": TimeZone.ASIA_ASHGABAT,
    "Antarctica/DumontDUrville": TimeZone.ANTARCTICA_DUMONT_DURVILLE,
    "US/East-Indiana": TimeZone.US_EAST_IND,
    "Asia/Irkutsk": TimeZone.ASIA_IRKUTSK,
    "America/Mazatlan": TimeZone.AMERICA_MAZATLAN,
    "Pacific/Apia": TimeZone.PACIFIC_APIA,
    "America/Boa_Vista": TimeZone.AMERICA_BOA_VISTA,
    "Etc/GMT": TimeZone.ETC_GMT,
    "America/Guyana": TimeZone.AMERICA_GUYANA,
    "Australia/Currie": TimeZone.AUSTRALIA_CURRIE,
    "Europe/Ulyanovsk": TimeZone.EUROPE_ULYANOVSK,
    "Pacific/Fakaofo": TimeZone.PACIFIC_FAKAOFO,
    "America/North_Dakota/Beulah": TimeZone.AMERICA_NORTH_DAKOTA_BEULAH,
    "Europe/Prague": TimeZone.EUROPE_PRAGUE,
    "Asia/Qatar": TimeZone.ASIA_QATAR,
    "Pacific/Funafuti": TimeZone.PACIFIC_FUNAFUTI,
    "Jamaica": TimeZone.JAMAICA,
    "Canada/Eastern": TimeZone.CANADA_EASTERN,
    "Pacific/Guam": TimeZone.PACIFIC_GUAM,
    "Pacific/Fiji": TimeZone.PACIFIC_FIJI,
    "Africa/Kigali": TimeZone.AFRICA_KIGALI,
    "Pacific/Tongatapu": TimeZone.PACIFIC_TONGATAPU,
    "America/Lima": TimeZone.AMERICA_LIMA,
    "Asia/Muscat": TimeZone.ASIA_MUSCAT,
    "Antarctica/Macquarie": TimeZone.ANTARCTICA_MACQUARIE,
    "Etc/GMT-2": TimeZone.ETC_GMT_MINUS_2,
    "Pacific/Pitcairn": TimeZone.PACIFIC_PITCAIRN,
    "Canada/Mountain": TimeZone.CANADA_MOUNTAIN,
    "Asia/Yekaterinburg": TimeZone.ASIA_YEKATERINBURG,
    "Pacific/Johnston": TimeZone.PACIFIC_JOHNSTON,
    "Europe/Vatican": TimeZone.EUROPE_VATICAN,
    "Atlantic/Bermuda": TimeZone.ATLANTIC_BERMUDA,
    "Asia/Jerusalem": TimeZone.ASIA_JERUSALEM,
    "America/Ciudad_Juarez": TimeZone.AMERICA_CIUDAD_JUAREZ,
    "Pacific/Galapagos": TimeZone.PACIFIC_GALAPAGOS,
    "America/Montreal": TimeZone.AMERICA_MONTREAL,
    "Africa/Nouakchott": TimeZone.AFRICA_NOUAKCHOTT,
    "US/Arizona": TimeZone.US_ARIZONA,
    "Asia/Kuching": TimeZone.ASIA_KUCHING,
    "Etc/GMT+4": TimeZone.ETC_GMT_PLUS_4,
    "Australia/Brisbane": TimeZone.AUSTRALIA_BRISBANE,
    "Canada/Saskatchewan": TimeZone.CANADA_SASKATCHEWAN,
    "Europe/Dublin": TimeZone.EUROPE_DUBLIN,
    "Asia/Qostanay": TimeZone.ASIA_QOSTANAY,
    "America/Edmonton": TimeZone.AMERICA_EDMONTON,
    "Atlantic/Reykjavik": TimeZone.ATLANTIC_REYKJAVIK,
    "America/Fortaleza": TimeZone.AMERICA_FORTALEZA,
    "Pacific/Kiritimati": TimeZone.PACIFIC_KIRITIMATI,
    "Etc/Universal": TimeZone.ETC_UNIVERSAL,
    "GMT0": TimeZone.GMT0,
    "Europe/Belfast": TimeZone.EUROPE_BELFAST,
    "Pacific/Yap": TimeZone.PACIFIC_YAP,
    "America/Santo_Domingo": TimeZone.AMERICA_SANTO_DOMINGO,
    "Iceland": TimeZone.ICELAND,
    "America/Araguaina": TimeZone.AMERICA_ARAGUAINA,
    "Asia/Karachi": TimeZone.ASIA_KARACHI,
    "Etc/GMT+7": TimeZone.ETC_GMT_PLUS_7,
    "Africa/Bujumbura": TimeZone.AFRICA_BUJUMBURA,
    "America/Dawson_Creek": TimeZone.AMERICA_DAWSON_CREEK,
    "Europe/Zaporozhye": TimeZone.EUROPE_ZAPOROZHYE,
    "Asia/Ulaanbaatar": TimeZone.ASIA_ULAANBAATAR,
    "Pacific/Samoa": TimeZone.PACIFIC_SAMOA,
    "Australia/Darwin": TimeZone.AUSTRALIA_DARWIN,
    "Etc/GMT0": TimeZone.ETC_GMT0,
    "Pacific/Tahiti": TimeZone.PACIFIC_TAHITI,
    "Etc/GMT-8": TimeZone.ETC_GMT_MINUS_8,
    "Atlantic/Faeroe": TimeZone.ATLANTIC_FAEROE,
    "Africa/Libreville": TimeZone.AFRICA_LIBREVILLE,
    "Asia/Barnaul": TimeZone.ASIA_BARNAUL,
    "America/Coral_Harbour": TimeZone.AMERICA_CORAL_HARBOUR,
    "Antarctica/Syowa": TimeZone.ANTARCTICA_SYOWA,
    "America/Buenos_Aires": TimeZone.AMERICA_BUENOS_AIRES,
    "Europe/Vienna": TimeZone.EUROPE_VIENNA,
    "America/Fort_Wayne": TimeZone.AMERICA_FORT_WAYNE,
    "NZ": TimeZone.NZ,
    "Atlantic/Azores": TimeZone.ATLANTIC_AZORES,
    "America/Coyhaique": TimeZone.AMERICA_COYHAIQUE,
    "Asia/Pyongyang": TimeZone.ASIA_PYONGYANG,
    "Etc/GMT-10": TimeZone.ETC_GMT_MINUS_10,
    "MST": TimeZone.MST,
    "America/Argentina/Jujuy": TimeZone.AMERICA_ARGENTINA_JUJUY,
    "America/Tijuana": TimeZone.AMERICA_TIJUANA,
    "Pacific/Guadalcanal": TimeZone.PACIFIC_GUADALCANAL,
    "Europe/Stockholm": TimeZone.EUROPE_STOCKHOLM,
    "US/Alaska": TimeZone.US_ALASKA,
    "Europe/Tiraspol": TimeZone.EUROPE_TIRASPOL,
    "Europe/Samara": TimeZone.EUROPE_SAMARA,
    "Etc/GMT-12": TimeZone.ETC_GMT_MINUS_12,
    "Kwajalein": TimeZone.KWAJALEIN,
    "Asia/Macau": TimeZone.ASIA_MACAU,
    "Pacific/Truk": TimeZone.PACIFIC_TRUK,
    "Asia/Bangkok": TimeZone.ASIA_BANGKOK,
    "America/Antigua": TimeZone.AMERICA_ANTIGUA,
    "Africa/El_Aaiun": TimeZone.AFRICA_EL_AAIUN,
    "Europe/Mariehamn": TimeZone.EUROPE_MARIEHAMN,
    "Asia/Jayapura": TimeZone.ASIA_JAYAPURA,
    "Europe/San_Marino": TimeZone.EUROPE_SAN_MARINO,
    "US/Pacific": TimeZone.US_PACIFIC,
    "Africa/Johannesburg": TimeZone.AFRICA_JOHANNESBURG,
    "Australia/Eucla": TimeZone.AUSTRALIA_EUCLA,
    "Africa/Nairobi": TimeZone.AFRICA_NAIROBI,
    "Etc/GMT-7": TimeZone.ETC_GMT_MINUS_7,
    "America/Inuvik": TimeZone.AMERICA_INUVIK,
    "Asia/Tokyo": TimeZone.ASIA_TOKYO,
    "Asia/Atyrau": TimeZone.ASIA_ATYRAU,
    "Asia/Kashgar": TimeZone.ASIA_KASHGAR,
    "W-SU": TimeZone.W_SU,
    "Asia/Tashkent": TimeZone.ASIA_TASHKENT,
    "Africa/Freetown": TimeZone.AFRICA_FREETOWN,
    "Pacific/Pago_Pago": TimeZone.PACIFIC_PAGO_PAGO,
    "America/Denver": TimeZone.AMERICA_DENVER,
    "Australia/LHI": TimeZone.AUSTRALIA_LHI,
    "Pacific/Rarotonga": TimeZone.PACIFIC_RAROTONGA,
    "MST7MDT": TimeZone.MST7MDT,
    "Pacific/Noumea": TimeZone.PACIFIC_NOUMEA,
    "Etc/UCT": TimeZone.ETC_UCT,
    "Etc/GMT+10": TimeZone.ETC_GMT_PLUS_10,
    "ROK": TimeZone.ROK,
    "Pacific/Auckland": TimeZone.PACIFIC_AUCKLAND,
    "Asia/Novokuznetsk": TimeZone.ASIA_NOVOKUZNETSK,
    "America/Hermosillo": TimeZone.AMERICA_HERMOSILLO,
    "America/Louisville": TimeZone.AMERICA_LOUISVILLE,
    "Asia/Ho_Chi_Minh": TimeZone.ASIA_HO_CHI_MINH,
    "Asia/Yerevan": TimeZone.ASIA_YEREVAN,
    "Asia/Yakutsk": TimeZone.ASIA_YAKUTSK,
    "Universal": TimeZone.UNIVERSAL,
    "America/Tegucigalpa": TimeZone.AMERICA_TEGUCIGALPA,
    "Mexico/BajaNorte": TimeZone.MEXICO_BAJANORTE,
    "Europe/Sarajevo": TimeZone.EUROPE_SARAJEVO,
    "America/Argentina/Catamarca": TimeZone.AMERICA_ARGENTINA_CATAMARCA,
    "Cuba": TimeZone.CUBA,
    "Asia/Khandyga": TimeZone.ASIA_KHANDYGA,
    "America/Lower_Princes": TimeZone.AMERICA_LOWER_PRINCES,
    "America/Blanc-Sablon": TimeZone.AMERICA_BLANC_SABLON,
    "America/Bogota": TimeZone.AMERICA_BOGOTA,
    "Africa/Lome": TimeZone.AFRICA_LOME,
    "America/Toronto": TimeZone.AMERICA_TORONTO,
    "Europe/Warsaw": TimeZone.EUROPE_WARSAW,
    "America/Yellowknife": TimeZone.AMERICA_YELLOWKNIFE,
    "America/Swift_Current": TimeZone.AMERICA_SWIFT_CURRENT,
    "EST": TimeZone.EST,
    "Europe/Sofia": TimeZone.EUROPE_SOFIA,
    "Africa/Ceuta": TimeZone.AFRICA_CEUTA,
    "America/Marigot": TimeZone.AMERICA_MARIGOT,
    "America/Danmarkshavn": TimeZone.AMERICA_DANMARKSHAVN,
    "Africa/Harare": TimeZone.AFRICA_HARARE,
    "UTC": TimeZone.UTC,
    "UTC+1": TimeZone.UTC_PLUS_1,
    "UTC+2": TimeZone.UTC_PLUS_2,
    "UTC+3": TimeZone.UTC_PLUS_3,
    "UTC+4": TimeZone.UTC_PLUS_4,
    "UTC+5": TimeZone.UTC_PLUS_5,
    "UTC+6": TimeZone.UTC_PLUS_6,
    "UTC+7": TimeZone.UTC_PLUS_7,
    "UTC+8": TimeZone.UTC_PLUS_8,
    "UTC+9": TimeZone.UTC_PLUS_9,
    "UTC+10": TimeZone.UTC_PLUS_10,
    "UTC+11": TimeZone.UTC_PLUS_11,
    "UTC+12": TimeZone.UTC_PLUS_12,
    "UTC-1": TimeZone.UTC_MINUS_1,
    "UTC-2": TimeZone.UTC_MINUS_2,
    "UTC-3": TimeZone.UTC_MINUS_3,
    "UTC-4": TimeZone.UTC_MINUS_4,
    "UTC-5": TimeZone.UTC_MINUS_5,
    "UTC-6": TimeZone.UTC_MINUS_6,
    "UTC-7": TimeZone.UTC_MINUS_7,
    "UTC-8": TimeZone.UTC_MINUS_8,
    "UTC-9": TimeZone.UTC_MINUS_9,
    "UTC-10": TimeZone.UTC_MINUS_10,
    "UTC-11": TimeZone.UTC_MINUS_11,
    "UTC-12": TimeZone.UTC_MINUS_12,
    "EST5EDT": TimeZone.EST5EDT,
    "Pacific/Midway": TimeZone.PACIFIC_MIDWAY,
    "Asia/Istanbul": TimeZone.ASIA_ISTANBUL,
    "America/Argentina/ComodRivadavia": TimeZone.AMERICA_ARGENTINA_COMODRIVADAVIA,
    "Asia/Baku": TimeZone.ASIA_BAKU,
    "Australia/NSW": TimeZone.AUSTRALIA_NSW,
    "Europe/Busingen": TimeZone.EUROPE_BUSINGEN,
    "America/Regina": TimeZone.AMERICA_REGINA,
    "Africa/Bangui": TimeZone.AFRICA_BANGUI,
    "Poland": TimeZone.POLAND,
    "Indian/Christmas": TimeZone.INDIAN_CHRISTMAS,
    "Australia/Queensland": TimeZone.AUSTRALIA_QUEENSLAND,
    "Asia/Bishkek": TimeZone.ASIA_BISHKEK,
    "Asia/Dubai": TimeZone.ASIA_DUBAI,
    "Africa/Mbabane": TimeZone.AFRICA_MBABANE,
    "America/Grand_Turk": TimeZone.AMERICA_GRAND_TURK,
    "America/Glace_Bay": TimeZone.AMERICA_GLACE_BAY,
    "Pacific/Enderbury": TimeZone.PACIFIC_ENDERBURY,
    "Africa/Dakar": TimeZone.AFRICA_DAKAR,
    "Africa/Algiers": TimeZone.AFRICA_ALGIERS,
    "Asia/Damascus": TimeZone.ASIA_DAMASCUS,
    "America/Rankin_Inlet": TimeZone.AMERICA_RANKIN_INLET,
    "Europe/Brussels": TimeZone.EUROPE_BRUSSELS,
    "Asia/Hovd": TimeZone.ASIA_HOVD,
    "Australia/Hobart": TimeZone.AUSTRALIA_HOBART,
    "Europe/Bucharest": TimeZone.EUROPE_BUCHAREST,
    "Asia/Gaza": TimeZone.ASIA_GAZA,
    "Iran": TimeZone.IRAN,
    "Africa/Djibouti": TimeZone.AFRICA_DJIBOUTI,
    "America/Rosario": TimeZone.AMERICA_ROSARIO,
    "Europe/Belgrade": TimeZone.EUROPE_BELGRADE,
    "Antarctica/Rothera": TimeZone.ANTARCTICA_ROTHERA,
    "Africa/Addis_Ababa": TimeZone.AFRICA_ADDIS_ABABA,
    "Asia/Dacca": TimeZone.ASIA_DACCA,
    "Asia/Krasnoyarsk": TimeZone.ASIA_KRASNOYARSK,
    "Europe/Chisinau": TimeZone.EUROPE_CHISINAU,
    "Indian/Cocos": TimeZone.INDIAN_COCOS,
    "America/Indiana/Vincennes": TimeZone.AMERICA_INDIANA_VINCENNES,
    "America/Cambridge_Bay": TimeZone.AMERICA_CAMBRIDGE_BAY,
    "Asia/Thimphu": TimeZone.ASIA_THIMPHU,
    "Europe/Riga": TimeZone.EUROPE_RIGA,
    "US/Mountain": TimeZone.US_MOUNTAIN,
    "Egypt": TimeZone.EGYPT,
    "America/Argentina/Tucuman": TimeZone.AMERICA_ARGENTINA_TUCUMAN,
    "Atlantic/St_Helena": TimeZone.ATLANTIC_ST_HELENA,
    "Greenwich": TimeZone.GREENWICH,
    "Asia/Ashkhabad": TimeZone.ASIA_ASHKHABAD,
    "Europe/Nicosia": TimeZone.EUROPE_NICOSIA,
    "Asia/Aqtau": TimeZone.ASIA_AQTAU,
    "Antarctica/Mawson": TimeZone.ANTARCTICA_MAWSON,
    "America/North_Dakota/Center": TimeZone.AMERICA_NORTH_DAKOTA_CENTER,
    "EET": TimeZone.EET,
    "ROC": TimeZone.ROC,
    "America/Mendoza": TimeZone.AMERICA_MENDOZA,
    "America/St_Vincent": TimeZone.AMERICA_ST_VINCENT,
    "CST6CDT": TimeZone.CST6CDT,
    "Asia/Bahrain": TimeZone.ASIA_BAHRAIN,
    "Asia/Riyadh": TimeZone.ASIA_RIYADH,
    "Pacific/Efate": TimeZone.PACIFIC_EFATE,
    "Indian/Mauritius": TimeZone.INDIAN_MAURITIUS,
    "Indian/Kerguelen": TimeZone.INDIAN_KERGUELEN,
    "Asia/Colombo": TimeZone.ASIA_COLOMBO,
    "Africa/Maseru": TimeZone.AFRICA_MASERU,
    "America/Asuncion": TimeZone.AMERICA_ASUNCION,
    "Europe/Copenhagen": TimeZone.EUROPE_COPENHAGEN,
    "America/Argentina/Salta": TimeZone.AMERICA_ARGENTINA_SALTA,
    "Africa/Malabo": TimeZone.AFRICA_MALABO,
    "America/Matamoros": TimeZone.AMERICA_MATAMOROS,
    "America/Argentina/La_Rioja": TimeZone.AMERICA_ARGENTINA_LA_RIOJA,
    "Africa/Accra": TimeZone.AFRICA_ACCRA,
    "Eire": TimeZone.EIRE,
    "America/Kentucky/Louisville": TimeZone.AMERICA_KENTUCKY_LOUISVILLE,
    "Africa/Bamako": TimeZone.AFRICA_BAMAKO,
    "Etc/GMT-5": TimeZone.ETC_GMT_5,
    "Pacific/Chatham": TimeZone.PACIFIC_CHATHAM,
    "WET": TimeZone.WET,
    "Etc/GMT+5": TimeZone.ETC_GMT_PLUS_5,
    "Africa/Mogadishu": TimeZone.AFRICA_MOGADISHU,
    "America/Thule": TimeZone.AMERICA_THULE,
    "America/Phoenix": TimeZone.AMERICA_PHOENIX,
    "Australia/Lord_Howe": TimeZone.AUSTRALIA_LORD_HOWE,
    "Pacific/Chuuk": TimeZone.PACIFIC_CHUUK,
    "Pacific/Marquesas": TimeZone.PACIFIC_MARQUESAS,
    "Pacific/Wake": TimeZone.PACIFIC_WAKE,
    "Africa/Brazzaville": TimeZone.AFRICA_BRAZZAVILLE,
    "Australia/Broken_Hill": TimeZone.AUSTRALIA_BROKEN_HILL,
    "Australia/South": TimeZone.AUSTRALIA_SOUTH,
    "America/Kentucky/Monticello": TimeZone.AMERICA_KENTUCKY_MONTICELLO,
    "Europe/Kiev": TimeZone.EUROPE_KIEV,
    "Etc/GMT-9": TimeZone.ETC_GMT_9,
    "Australia/Lindeman": TimeZone.AUSTRALIA_LINDEMAN,
    "America/Metlakatla": TimeZone.AMERICA_METLAKATLA,
    "America/Goose_Bay": TimeZone.AMERICA_GOOSE_BAY,
    "America/St_Lucia": TimeZone.AMERICA_ST_LUCIA,
    "Europe/Ljubljana": TimeZone.EUROPE_LJUBLJANA,
    "Europe/Tirane": TimeZone.EUROPE_TIRANE,
    "America/Santarem": TimeZone.AMERICA_SANTAREM,
    "Atlantic/Canary": TimeZone.ATLANTIC_CANARY,
    "America/Grenada": TimeZone.AMERICA_GRENADA,
    "America/Shiprock": TimeZone.AMERICA_SHIPROCK,
    "Europe/Skopje": TimeZone.EUROPE_SKOPJE,
    "Etc/GMT+8": TimeZone.ETC_GMT_PLUS_8,
    "Asia/Baghdad": TimeZone.ASIA_BAGHDAD,
    "Australia/Sydney": TimeZone.AUSTRALIA_SYDNEY,
    "Europe/Istanbul": TimeZone.EUROPE_ISTANBUL,
    "America/Dominica": TimeZone.AMERICA_DOMINICA,
    "America/Nipigon": TimeZone.AMERICA_NIPIGON,
    "Asia/Calcutta": TimeZone.ASIA_CALCUTTA,
    "Etc/GMT-0": TimeZone.ETC_GMT_0,
    "Antarctica/Casey": TimeZone.ANTARCTICA_CASEY,
    "Asia/Vladivostok": TimeZone.ASIA_VLADIVOSTOK,
    "America/Godthab": TimeZone.AMERICA_GODTHAB,
    "Asia/Aqtube": TimeZone.ASIA_AQTUBE,
    "Europe/Kirov": TimeZone.EUROPE_KIROV,
    "Asia/Aden": TimeZone.ASIA_ADEN,
    "Europe/Isle_of_Man": TimeZone.EUROPE_ISLE_OF_MAN,
}
