"""Description: This file contains the Django models generated from the existing database schema using the inspectdb command.
Each class represents a table in the database, and the fields correspond to the table columns."""

from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Circuit(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    full_name = models.CharField(max_length=100)
    previous_names = models.CharField(max_length=255, blank=True, null=True)
    type = models.CharField(max_length=6)
    place_name = models.CharField(max_length=100)
    country = models.ForeignKey('Country', models.DO_NOTHING)
    latitude = models.DecimalField(max_digits=10, decimal_places=6)
    longitude = models.DecimalField(max_digits=10, decimal_places=6)
    total_races_held = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'circuit'


class Constructor(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    full_name = models.CharField(max_length=100)
    country = models.ForeignKey('Country', models.DO_NOTHING)
    best_championship_position = models.IntegerField(blank=True, null=True)
    best_starting_grid_position = models.IntegerField(blank=True, null=True)
    best_race_result = models.IntegerField(blank=True, null=True)
    total_championship_wins = models.IntegerField()
    total_race_entries = models.IntegerField()
    total_race_starts = models.IntegerField()
    total_race_wins = models.IntegerField()
    total_1_and_2_finishes = models.IntegerField()
    total_race_laps = models.IntegerField()
    total_podiums = models.IntegerField()
    total_podium_races = models.IntegerField()
    total_championship_points = models.DecimalField(max_digits=8, decimal_places=2)
    total_pole_positions = models.IntegerField()
    total_fastest_laps = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'constructor'


class ConstructorPreviousNextConstructor(models.Model):
    constructor = models.OneToOneField(Constructor, models.DO_NOTHING, primary_key=True)  # The composite primary key (constructor_id, previous_next_constructor_id, year_from) found, that is not supported. The first column is selected.
    previous_next_constructor = models.ForeignKey(Constructor, models.DO_NOTHING, related_name='constructorpreviousnextconstructor_previous_next_constructor_set')
    year_from = models.IntegerField()
    year_to = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'constructor_previous_next_constructor'
        unique_together = (('constructor', 'previous_next_constructor', 'year_from'),)


class Continent(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    code = models.CharField(unique=True, max_length=2)
    name = models.CharField(unique=True, max_length=100)
    demonym = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'continent'


class Country(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    alpha2_code = models.CharField(unique=True, max_length=2)
    alpha3_code = models.CharField(unique=True, max_length=3)
    name = models.CharField(unique=True, max_length=100)
    demonym = models.CharField(max_length=100, blank=True, null=True)
    continent = models.ForeignKey(Continent, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'country'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Driver(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    full_name = models.CharField(max_length=100)
    abbreviation = models.CharField(max_length=3)
    permanent_number = models.CharField(max_length=2, blank=True, null=True)
    gender = models.CharField(max_length=6)
    date_of_birth = models.DateField()
    date_of_death = models.DateField(blank=True, null=True)
    place_of_birth = models.CharField(max_length=100)
    country_of_birth_country = models.ForeignKey(Country, models.DO_NOTHING)
    nationality_country = models.ForeignKey(Country, models.DO_NOTHING, related_name='driver_nationality_country_set')
    second_nationality_country = models.ForeignKey(Country, models.DO_NOTHING, related_name='driver_second_nationality_country_set', blank=True, null=True)
    best_championship_position = models.IntegerField(blank=True, null=True)
    best_starting_grid_position = models.IntegerField(blank=True, null=True)
    best_race_result = models.IntegerField(blank=True, null=True)
    total_championship_wins = models.IntegerField()
    total_race_entries = models.IntegerField()
    total_race_starts = models.IntegerField()
    total_race_wins = models.IntegerField()
    total_race_laps = models.IntegerField()
    total_podiums = models.IntegerField()
    total_points = models.DecimalField(max_digits=8, decimal_places=2)
    total_championship_points = models.DecimalField(max_digits=8, decimal_places=2)
    total_pole_positions = models.IntegerField()
    total_fastest_laps = models.IntegerField()
    total_driver_of_the_day = models.IntegerField()
    total_grand_slams = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'driver'


class DriverFamilyRelationship(models.Model):
    driver = models.OneToOneField(Driver, models.DO_NOTHING, primary_key=True)  # The composite primary key (driver_id, other_driver_id, type) found, that is not supported. The first column is selected.
    other_driver = models.ForeignKey(Driver, models.DO_NOTHING, related_name='driverfamilyrelationship_other_driver_set')
    type = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'driver_family_relationship'
        unique_together = (('driver', 'other_driver', 'type'),)


class EngineManufacturer(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    country = models.ForeignKey(Country, models.DO_NOTHING)
    best_championship_position = models.IntegerField(blank=True, null=True)
    best_starting_grid_position = models.IntegerField(blank=True, null=True)
    best_race_result = models.IntegerField(blank=True, null=True)
    total_championship_wins = models.IntegerField()
    total_race_entries = models.IntegerField()
    total_race_starts = models.IntegerField()
    total_race_wins = models.IntegerField()
    total_race_laps = models.IntegerField()
    total_podiums = models.IntegerField()
    total_podium_races = models.IntegerField()
    total_championship_points = models.DecimalField(max_digits=8, decimal_places=2)
    total_pole_positions = models.IntegerField()
    total_fastest_laps = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'engine_manufacturer'


class Entrant(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'entrant'


class GrandPrix(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    full_name = models.CharField(max_length=100)
    short_name = models.CharField(max_length=100)
    abbreviation = models.CharField(max_length=3)
    country = models.ForeignKey(Country, models.DO_NOTHING, blank=True, null=True)
    total_races_held = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'grand_prix'


class Race(models.Model):
    id = models.IntegerField(primary_key=True)
    year = models.ForeignKey('Season', models.DO_NOTHING, db_column='year')
    round = models.IntegerField()
    date = models.DateField()
    time = models.TextField(blank=True, null=True)
    grand_prix = models.ForeignKey(GrandPrix, models.DO_NOTHING)
    official_name = models.CharField(max_length=100)
    qualifying_format = models.CharField(max_length=20)
    sprint_qualifying_format = models.CharField(max_length=20, blank=True, null=True)
    circuit = models.ForeignKey(Circuit, models.DO_NOTHING)
    circuit_type = models.CharField(max_length=6)
    course_length = models.DecimalField(max_digits=6, decimal_places=3)
    laps = models.IntegerField()
    distance = models.DecimalField(max_digits=6, decimal_places=3)
    scheduled_laps = models.IntegerField(blank=True, null=True)
    scheduled_distance = models.DecimalField(max_digits=6, decimal_places=3, blank=True, null=True)
    pre_qualifying_date = models.DateField(blank=True, null=True)
    pre_qualifying_time = models.CharField(max_length=5, blank=True, null=True)
    free_practice_1_date = models.DateField(blank=True, null=True)
    free_practice_1_time = models.CharField(max_length=5, blank=True, null=True)
    free_practice_2_date = models.DateField(blank=True, null=True)
    free_practice_2_time = models.CharField(max_length=5, blank=True, null=True)
    free_practice_3_date = models.DateField(blank=True, null=True)
    free_practice_3_time = models.CharField(max_length=5, blank=True, null=True)
    free_practice_4_date = models.DateField(blank=True, null=True)
    free_practice_4_time = models.CharField(max_length=5, blank=True, null=True)
    qualifying_1_date = models.DateField(blank=True, null=True)
    qualifying_1_time = models.CharField(max_length=5, blank=True, null=True)
    qualifying_2_date = models.DateField(blank=True, null=True)
    qualifying_2_time = models.CharField(max_length=5, blank=True, null=True)
    qualifying_date = models.DateField(blank=True, null=True)
    qualifying_time = models.CharField(max_length=5, blank=True, null=True)
    sprint_qualifying_date = models.DateField(blank=True, null=True)
    sprint_qualifying_time = models.CharField(max_length=5, blank=True, null=True)
    sprint_race_date = models.DateField(blank=True, null=True)
    sprint_race_time = models.CharField(max_length=5, blank=True, null=True)
    warming_up_date = models.DateField(blank=True, null=True)
    warming_up_time = models.CharField(max_length=5, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'race'
        unique_together = (('year', 'round'),)


class RaceConstructorStanding(models.Model):
    race = models.OneToOneField(Race, models.DO_NOTHING, primary_key=True)  # The composite primary key (race_id, position_display_order) found, that is not supported. The first column is selected.
    position_display_order = models.IntegerField()
    position_number = models.IntegerField(blank=True, null=True)
    position_text = models.CharField(max_length=4)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)
    points = models.DecimalField(max_digits=8, decimal_places=2)
    positions_gained = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'race_constructor_standing'
        unique_together = (('race', 'position_display_order'),)


class RaceData(models.Model):
    race = models.OneToOneField(Race, models.DO_NOTHING, primary_key=True)  # The composite primary key (race_id, type, position_display_order) found, that is not supported. The first column is selected.
    type = models.CharField(max_length=50)
    position_display_order = models.IntegerField()
    position_number = models.IntegerField(blank=True, null=True)
    position_text = models.CharField(max_length=4)
    driver_number = models.CharField(max_length=3)
    driver = models.ForeignKey(Driver, models.DO_NOTHING)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)
    tyre_manufacturer = models.ForeignKey('TyreManufacturer', models.DO_NOTHING)
    practice_time = models.CharField(max_length=20, blank=True, null=True)
    practice_time_millis = models.IntegerField(blank=True, null=True)
    practice_gap = models.CharField(max_length=20, blank=True, null=True)
    practice_gap_millis = models.IntegerField(blank=True, null=True)
    practice_interval = models.CharField(max_length=20, blank=True, null=True)
    practice_interval_millis = models.IntegerField(blank=True, null=True)
    practice_laps = models.IntegerField(blank=True, null=True)
    qualifying_time = models.CharField(max_length=20, blank=True, null=True)
    qualifying_time_millis = models.IntegerField(blank=True, null=True)
    qualifying_q1 = models.CharField(max_length=20, blank=True, null=True)
    qualifying_q1_millis = models.IntegerField(blank=True, null=True)
    qualifying_q2 = models.CharField(max_length=20, blank=True, null=True)
    qualifying_q2_millis = models.IntegerField(blank=True, null=True)
    qualifying_q3 = models.CharField(max_length=20, blank=True, null=True)
    qualifying_q3_millis = models.IntegerField(blank=True, null=True)
    qualifying_gap = models.CharField(max_length=20, blank=True, null=True)
    qualifying_gap_millis = models.IntegerField(blank=True, null=True)
    qualifying_interval = models.CharField(max_length=20, blank=True, null=True)
    qualifying_interval_millis = models.IntegerField(blank=True, null=True)
    qualifying_laps = models.IntegerField(blank=True, null=True)
    starting_grid_position_grid_penalty = models.CharField(max_length=20, blank=True, null=True)
    starting_grid_position_grid_penalty_positions = models.IntegerField(blank=True, null=True)
    starting_grid_position_time = models.CharField(max_length=20, blank=True, null=True)
    starting_grid_position_time_millis = models.IntegerField(blank=True, null=True)
    race_shared_car = models.BooleanField(blank=True, null=True)
    race_laps = models.IntegerField(blank=True, null=True)
    race_time = models.CharField(max_length=20, blank=True, null=True)
    race_time_millis = models.IntegerField(blank=True, null=True)
    race_time_penalty = models.CharField(max_length=20, blank=True, null=True)
    race_time_penalty_millis = models.IntegerField(blank=True, null=True)
    race_gap = models.CharField(max_length=20, blank=True, null=True)
    race_gap_millis = models.IntegerField(blank=True, null=True)
    race_gap_laps = models.IntegerField(blank=True, null=True)
    race_interval = models.CharField(max_length=20, blank=True, null=True)
    race_interval_millis = models.IntegerField(blank=True, null=True)
    race_reason_retired = models.CharField(max_length=100, blank=True, null=True)
    race_points = models.DecimalField(max_digits=8, decimal_places=2, blank=True, null=True)
    race_grid_position_number = models.IntegerField(blank=True, null=True)
    race_grid_position_text = models.CharField(max_length=2, blank=True, null=True)
    race_positions_gained = models.IntegerField(blank=True, null=True)
    race_pit_stops = models.IntegerField(blank=True, null=True)
    race_fastest_lap = models.BooleanField(blank=True, null=True)
    race_driver_of_the_day = models.BooleanField(blank=True, null=True)
    race_grand_slam = models.BooleanField(blank=True, null=True)
    fastest_lap_lap = models.IntegerField(blank=True, null=True)
    fastest_lap_time = models.CharField(max_length=20, blank=True, null=True)
    fastest_lap_time_millis = models.IntegerField(blank=True, null=True)
    fastest_lap_gap = models.CharField(max_length=20, blank=True, null=True)
    fastest_lap_gap_millis = models.IntegerField(blank=True, null=True)
    fastest_lap_interval = models.CharField(max_length=20, blank=True, null=True)
    fastest_lap_interval_millis = models.IntegerField(blank=True, null=True)
    pit_stop_stop = models.IntegerField(blank=True, null=True)
    pit_stop_lap = models.IntegerField(blank=True, null=True)
    pit_stop_time = models.CharField(max_length=20, blank=True, null=True)
    pit_stop_time_millis = models.IntegerField(blank=True, null=True)
    driver_of_the_day_percentage = models.DecimalField(max_digits=4, decimal_places=1, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'race_data'
        unique_together = (('race', 'type', 'position_display_order'),)


class RaceDriverStanding(models.Model):
    race = models.OneToOneField(Race, models.DO_NOTHING, primary_key=True)  # The composite primary key (race_id, position_display_order) found, that is not supported. The first column is selected.
    position_display_order = models.IntegerField()
    position_number = models.IntegerField(blank=True, null=True)
    position_text = models.CharField(max_length=4)
    driver = models.ForeignKey(Driver, models.DO_NOTHING)
    points = models.DecimalField(max_digits=8, decimal_places=2)
    positions_gained = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'race_driver_standing'
        unique_together = (('race', 'position_display_order'),)


class Season(models.Model):
    year = models.IntegerField(primary_key=True)

    class Meta:
        managed = False
        db_table = 'season'


class SeasonConstructorStanding(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, position_display_order) found, that is not supported. The first column is selected.
    position_display_order = models.IntegerField()
    position_number = models.IntegerField(blank=True, null=True)
    position_text = models.CharField(max_length=4)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)
    points = models.DecimalField(max_digits=8, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'season_constructor_standing'
        unique_together = (('year', 'position_display_order'),)


class SeasonDriverStanding(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, position_display_order) found, that is not supported. The first column is selected.
    position_display_order = models.IntegerField()
    position_number = models.IntegerField(blank=True, null=True)
    position_text = models.CharField(max_length=4)
    driver = models.ForeignKey(Driver, models.DO_NOTHING)
    points = models.DecimalField(max_digits=8, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'season_driver_standing'
        unique_together = (('year', 'position_display_order'),)


class SeasonEntrant(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, entrant_id) found, that is not supported. The first column is selected.
    entrant = models.ForeignKey(Entrant, models.DO_NOTHING)
    country = models.ForeignKey(Country, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'season_entrant'
        unique_together = (('year', 'entrant'),)


class SeasonEntrantConstructor(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, entrant_id, constructor_id, engine_manufacturer_id) found, that is not supported. The first column is selected.
    entrant = models.ForeignKey(Entrant, models.DO_NOTHING)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'season_entrant_constructor'
        unique_together = (('year', 'entrant', 'constructor', 'engine_manufacturer'),)


class SeasonEntrantDriver(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, entrant_id, constructor_id, engine_manufacturer_id, driver_id) found, that is not supported. The first column is selected.
    entrant = models.ForeignKey(Entrant, models.DO_NOTHING)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)
    driver = models.ForeignKey(Driver, models.DO_NOTHING)
    rounds = models.CharField(max_length=100, blank=True, null=True)
    rounds_text = models.CharField(max_length=100, blank=True, null=True)
    test_driver = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'season_entrant_driver'
        unique_together = (('year', 'entrant', 'constructor', 'engine_manufacturer', 'driver'),)


class SeasonEntrantTyreManufacturer(models.Model):
    year = models.OneToOneField(Season, models.DO_NOTHING, db_column='year', primary_key=True)  # The composite primary key (year, entrant_id, constructor_id, engine_manufacturer_id, tyre_manufacturer_id) found, that is not supported. The first column is selected.
    entrant = models.ForeignKey(Entrant, models.DO_NOTHING)
    constructor = models.ForeignKey(Constructor, models.DO_NOTHING)
    engine_manufacturer = models.ForeignKey(EngineManufacturer, models.DO_NOTHING)
    tyre_manufacturer = models.ForeignKey('TyreManufacturer', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'season_entrant_tyre_manufacturer'
        unique_together = (('year', 'entrant', 'constructor', 'engine_manufacturer', 'tyre_manufacturer'),)


class TyreManufacturer(models.Model):
    id = models.CharField(primary_key=True, max_length=100)
    name = models.CharField(max_length=100)
    country = models.ForeignKey(Country, models.DO_NOTHING)
    best_starting_grid_position = models.IntegerField(blank=True, null=True)
    best_race_result = models.IntegerField(blank=True, null=True)
    total_race_entries = models.IntegerField()
    total_race_starts = models.IntegerField()
    total_race_wins = models.IntegerField()
    total_race_laps = models.IntegerField()
    total_podiums = models.IntegerField()
    total_podium_races = models.IntegerField()
    total_pole_positions = models.IntegerField()
    total_fastest_laps = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'tyre_manufacturer'
