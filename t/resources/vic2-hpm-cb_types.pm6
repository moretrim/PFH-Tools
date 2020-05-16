unit module vic2-hpm-cb_types;

#| Originally HPM/common/cb_types.txt, from HPM 0.4.6.3.
constant resource = q:to«END»;
# INSTRUCTIONS:
# -------------
# constructing_cb - default to yes. if "no", cant be picked for generation or as add_wargoal if no CB already
# is_triggered_only - Triggered from within the code or by event effects. DO NOT REMOVE THE STOCK ONES.
# mutual - The CB effects will also be used by the defender in peace treaties
# months - The number of months this CB will be valid. Only works for triggered CBs.
# prerequisites - A condition that automatically activates a CB. Does not work for triggered CBs. 'THIS' scope is the target country.
# badboy_factor - Multiplied with any badboy increase normally associated with a peace option.
# prestige_factor - Multiplied with any prestige increase normally associated with a peace option.
# peace_cost_factor - Multiplied with the cost of the peace options in the peace treaty
# po_xxx - Peace options. If toggled on, badboy_factor and prestige_factor are multiplied with any associated base changes to these (see defines.txt.)
# allowed_states - If 'po_demand_states' is on, badboy_factor applies to these provinces. 'THIS' scope is us.
# on_add - effect triggered when war goal added (triggering country's scope)
# construction_speed - base modifier for how long creating this CB will take. default is 1. 1.2 means 20% faster
# great_war_obligatory - cb is always added to the peace offer/demand in great wars.
# po_remove_cores - may be used only with: po_transfer_provinces, po_demand_state, po_annex
# crisis - can be offered as a wargoal in a crisis
#
# The peace options are:
#po_annex
#po_demand_state
#po_add_to_sphere
#po_disarmament
#po_reparations
#po_transfer_provinces
#po_remove_prestige
#po_make_puppet
#po_release_puppet
#po_status_quo
#po_install_communist_gov_type
#po_uninstall_communist_gov_type
#po_remove_cores
#po_colony

# NOTE: The order in which the peace options are listed is the order in which the AI will normally prioritize them in peace treaties

# TRIGGERED - Triggered from within the code or by event effects
# --------------------------------------------------------------

# A note on naval requirements for overseas targets: `num_of_ports` has a curious behaviour where
# paths from the capital to coastal provinces are computed and the final result only accounts for
# those that are reachable. (This may only apply for inland capitals.)
#
# In particular hostile sieges (including those from rebels) block those computed paths, but not
# much else does. This bears repeating: a country may be fully occupied and/or covered in *roaming*
# armies, and this won't affect what `num_of_ports` reports. However if a single rebel brigade
# starts a 100-year siege on the capital in a country that is otherwise free of troubles, suddenly
# the whole country counts as being landlocked. (This singular behaviour also includes the fact that
# occupied ports seem to be accounted for, though paths to the owner's capital are never computed
# for them.)
#
# To sidestep these quirks and spare players the frustration of spuriously invalidated CBs, a
# different requirement is used instead: `any_owned_province = { port = yes }`.

# Order that CBs are executed in a peace treaty
peace_order = {
treaty_port_casus_belli
war_reparations
become_independent
dismantle_cb
dismantle_cb_add
dismantle_cb_add_new
colonial_competition
acquire_all_cores
acquire_core_state
restore_austrian_empire
colonial_reconquest_cb
restore_america
claim_holy_land
restore_british_raj
unification_casus_belli
civil_war
unification_annex_casus_belli
claim_colonial_region_full
annex_africa_full
colonial_conquest_full
annex_core_country
unification_add_to_sphere
add_to_sphere
unification_GP_humiliate
great_war_install_democracy
great_war_install_fascism
great_war_install_communism
uninstall_communist_gov_cb
install_democracy
install_fascism
install_communism
unification_humiliate_cb
take_from_sphere
liberate_country
free_peoples
free_allied_cores
free_balkans
monroe_doctrine
oriental_crisis
unification_release_puppet_cb
release_puppet
release_puppet_AI
steal_puppet
great_game_cb
make_puppet
install_fascism_make_puppet
install_communism_make_puppet
install_democracy_make_puppet
gunboat
cut_down_to_size
cut_down_to_size_boxer
humiliate
place_in_the_sun
dismantle_forts
china_acquire_state
acquire_state
acquire_any_state
acquire_substate_region
demand_concession_BC_casus_belli
demand_concession_NI_casus_belli
demand_concession_casus_belli
rude_boy
conquest
conquest_any
claim_colonial_region
colonial_conquest
annex_africa
establish_protectorate_BC_casus_belli
establish_protectorate_NI_casus_belli
establish_protectorate_casus_belli
status_quo
}

# Great War CB's
dismantle_cb = {
    sprite_index = 20
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 0.25

    badboy_factor = 2
    prestige_factor = 10
    peace_cost_factor = 35
    penalty_factor = 3

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 3
    break_truce_militancy_factor = 1
    truce_months = 108

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        OR = {
            is_greater_power = yes
            is_secondary_power = yes
            colonial_nation = yes
            any_owned_province = { is_overseas = yes }
        }
        is_disarmed = no
        is_vassal = no
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_flag = dismantle_declared }
        OR = {
            NOT = { relation = { who = THIS value = -100 } }
            war_with = THIS
        }
        THIS = {
            is_greater_power = yes
            is_disarmed = no
            mass_politics = 1
            NOT = {
                has_country_flag = in_great_war
                has_country_modifier = no_more_war
                has_country_modifier = neutrality_modifier
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
    }

    po_disarmament = yes
    po_reparations = yes

    war_name = WAR_DISMANTLE_NAME

    on_add = {
        FROM = {
            set_country_flag = dismantle_declared
        }
        move_issue_percentage = {
            from = pro_military
            to = jingoism
            value = 0.10
        }
        country_event = 96000
    }

    on_po_accepted = {
        set_country_flag = dismantling_treaty
    }
}

dismantle_cb_add = {
    sprite_index = 20
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 1.5

    badboy_factor = 0
    prestige_factor = 10
    peace_cost_factor = 35
    penalty_factor = 3
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 3
    break_truce_militancy_factor = 1
    truce_months = 108

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_modifier = neutrality_modifier }
        NOT = { has_country_flag = dismantle_declared }
        has_country_flag = in_great_war
        OR = {
            is_greater_power = yes
            is_secondary_power = yes
            colonial_nation = yes
            any_owned_province = { is_overseas = yes }
        }
        civilized = yes
        is_disarmed = no
        is_vassal = no
        war_with = THIS
        THIS = {
            NOT = { has_country_modifier = neutrality_modifier }
            has_country_flag = in_great_war
            is_greater_power = yes
            is_disarmed = no
            is_vassal = no
            mass_politics = 1
        }
    }

    po_disarmament = yes
    po_reparations = yes

    war_name = WAR_DISMANTLE_NAME

    on_add = {
        FROM = {
            set_country_flag = dismantle_declared
        }
        move_issue_percentage = {
            from = pro_military
            to = jingoism
            value = 0.10
        }
    }

    on_po_accepted = {
        set_country_flag = dismantling_treaty
    }
}

dismantle_cb_add_new = {
    sprite_index = 20
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 1.5

    badboy_factor = 0
    prestige_factor = 10
    peace_cost_factor = 35
    penalty_factor = 3
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 3
    break_truce_militancy_factor = 1
    truce_months = 108

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_flag = dismantle_declared }
        NOT = { has_country_modifier = neutrality_modifier }
        is_greater_power = yes
        is_disarmed = no
        is_vassal = no
        war_with = THIS
        THIS = {
            NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_flag = in_great_war }
            is_greater_power = yes
            is_disarmed = no
            is_vassal = no
            mass_politics = 1
        }
    }

    po_disarmament = yes
    po_reparations = yes

    war_name = WAR_DISMANTLE_NAME

    on_add = {
        FROM = {
            set_country_flag = dismantle_declared
        }
        move_issue_percentage = {
            from = pro_military
            to = jingoism
            value = 0.10
        }
        country_event = 96000
    }

    on_po_accepted = {
        set_country_flag = dismantling_treaty
    }
}

# Great War Penalty
great_war_penalty_cb = {
    sprite_index = 14
    is_triggered_only = yes
    months = 0
    crisis = no

    constructing_cb = no

    great_war_obligatory = yes

    badboy_factor = 1.3
    prestige_factor = 1
    peace_cost_factor = 3
    penalty_factor = 0

    break_truce_prestige_factor = 0
    break_truce_infamy_factor = 0
    break_truce_militancy_factor = 0
    truce_months = 108

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    po_disarmament = yes
    po_reparations = yes
    po_remove_prestige = yes

    war_name = WAR_NAME

    #can_use = {
    #    NOT = { is_our_vassal = THIS }
    #    is_disarmed = no
    #}

    on_add = {
    }

    on_po_accepted = {
        political_reform = no_draft
    }
}

# Acquire Core State
acquire_core_state = {
    sprite_index = 5
    is_triggered_only = yes
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.7
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
            any_neighbor_country = { substate_of = THIS }
        }
        NOT = { is_our_vassal = THIS }
        number_of_states = 2 # annex if you want their last state
        is_vassal = no
        any_owned_province = { is_core = THIS }
        NOT = { has_country_modifier = neutrality_modifier }
        THIS = { NOT = { has_country_modifier = neutrality_modifier } }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    allowed_states = {
        any_owned_province = { is_core = THIS }
        #NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            THIS = { ai = no }
			any_owned_province = { owner = { war_with = THIS } }
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
        }
    }

    po_demand_state = yes

    war_name = WAR_TAKE_CORE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event =    2650    # Territorial Loss event
    }
}

# Acquire All Core States
acquire_all_cores = {
    sprite_index = 5
    is_triggered_only = yes
    months = 12
    constructing_cb = no
    crisis = no

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 0.5
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        always = no
        NOT = { is_our_vassal = THIS }
        number_of_states = 2 # annex if you want their last state
        is_vassal = no
        any_owned_province = { is_core = THIS }
        any_owned_province = { NOT = { is_core = THIS } }
        NOT = { has_country_modifier = neutrality_modifier }
        THIS = {
            NOT = {
                has_country_modifier = neutrality_modifier
                AND = {
                    war_policy = pacifism
                    war = no
                }
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    allowed_countries = {
        FROM = { tag = THIS }
    }

    allowed_states = {
        any_owned_province = { is_core = THIS }
        #NOT = { any_owned_province = { is_capital = yes } }
    }

    all_allowed_states = yes
    po_transfer_provinces = yes

    war_name = WAR_ALL_CORES_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event =    2650    # Territorial Loss event
    }
}

restore_austrian_empire = {
    sprite_index = 21
    is_triggered_only = yes
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 0.7
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        THIS = {
            OR = {
                war_policy = jingoism
                war_policy = pro_military
                war_with = THIS
            }
            tag = AUS
            OR = {
                is_greater_power = yes
                is_secondary_power = yes
            }
        }
        is_vassal = no
        neighbour = THIS
        any_owned_province = {
            OR = {
                is_core = VEN
                is_core = SLO
                is_core = SLV
                is_core = BOH
                is_core = HUN
                is_core = GLM
                region = AUS_771
                region = AUS_780
                region = AUS_777
                region = AUS_654
                region = AUS_652
                region = AUS_657
            }
        }
        OR = {
            NOT = { tag = ITA }
            THIS = { NOT = { has_country_flag = accepts_italy } }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        #NOT = { in_sphere = THIS }
        OR = {
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
            war_with = THIS
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        any_owned_province = {
            OR = {
                is_core = VEN
                is_core = SLO
                is_core = SLV
                is_core = BOH
                is_core = HUN
                is_core = GLM
                region = AUS_771
                region = AUS_780
                region = AUS_777
                region = AUS_654
                region = AUS_652
                region = AUS_657
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_AUSTRIAN_EMPIRE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                is_core = KRA
                is_core = GLM
            }
            remove_core = KRA
        }
    }

}

colonial_reconquest_cb = {
    sprite_index = 2
    is_triggered_only = no
    months = 12

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        OR = {
            AND = {
                THIS = {
                    OR = {
                        tag = SPA
                        tag = SPC
                    }
                    NOT = { has_global_flag = spanish_american_war }
                }
                OR = {
                    tag = PRI
                    tag = CUB
                    tag = PHL
                }
            }
            AND = {
                THIS = {
                    tag = NET
                    has_country_flag = conquest_of_jambi
                }
                tag = DJA
            }
            AND = {
                THIS = {
                    tag = NET
                    has_country_flag = javanese_integrated
                }
                tag = JAV
            }
            AND = {
                THIS = {
                    tag = NET
                    has_country_flag = tidore_integrated
                }
                tag = MAL
            }
        }
        NOT = { number_of_states = 3 }
        is_vassal = no
        OR = {
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
            war_with = THIS
        }
        THIS = {
            OR = {
                is_secondary_power = yes
                is_greater_power = yes
            }
            OR = {
                government = absolute_monarchy
                government = prussian_constitutionalism
                government = hms_government
            }
            NOT = { revolution_n_counterrevolution = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    po_annex = yes

    war_name = WAR_COLONIAL_RECONQUEST_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

restore_america = {
    sprite_index = 21
    is_triggered_only = yes
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 0.7
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        war_policy = jingoism
        NOT = { is_our_vassal = THIS }
        THIS = {
            OR = {
                primary_culture = yankee
                primary_culture = dixie
                primary_culture = texan
            }
            NOT = { tag = USA }
        }
        OR = {
            THIS = { has_global_flag = second_american_civil_war }
            USA = { exists = no }
        }
        OR = {
            THIS = { ai = no }
            THIS = {
                OR = {
                    war_policy = pro_military
                    war_policy = jingoism
                }
            }
            war_with = THIS
        }
        is_vassal = no
        neighbour = THIS
        any_owned_province = {
            OR = {
                is_core = USA
                is_core = CSA
                is_core = FSA
            }
        }
        #NOT = { in_sphere = THIS }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        any_owned_province = {
            OR = {
                is_core = USA
                is_core = CSA
                is_core = FSA
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_RESTORE_AMERICA_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

claim_holy_land = {
    sprite_index = 23
    is_triggered_only = yes
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 0.7
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        THIS = {
            is_greater_power = yes
            OR = {
                tag = FRA
                tag = ENG
                tag = AUS
                tag = KUK
                is_culture_group = east_slavic
                is_culture_group = south_slavic
                is_culture_group = italian
                is_culture_group = iberian
            }
            has_global_flag = abandoned_holy_land
        }
        OR = {
            THIS = {
                OR = {
                    war_policy = pro_military
                    war_policy = jingoism
                }
            }
            war_with = THIS
        }
        is_vassal = no
        NOT = { is_canal_enabled = 2 }
        NOT = { is_greater_power = yes }
        any_owned_province = {
            OR = {
                is_core = PLS
                is_core = JOR
                is_core = LBN
                is_core = SYR
            }
        }
        #NOT = { in_sphere = THIS }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        any_owned_province = {
            OR = {
                is_core = PLS
                is_core = JOR
                is_core = LBN
                is_core = SYR
            }
        }
        OR = {
            THIS = { ai = no }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = {
                    OR = {
                        is_greater_power = yes
                        is_secondary_power = yes
                    }
                    any_owned_province = { port = yes }
                }
            }
        }
    }

    po_demand_state = yes
    po_remove_cores = yes

    war_name = WAR_HOLY_LAND_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Unification Demand State
unification_casus_belli = {
    sprite_index = 22
    is_triggered_only = no
    months = 12
    construction_speed = 1
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        is_vassal = no
        NOT = { is_our_vassal = THIS }
        NOT = { tag = PRU }
        NOT = { tag = NGF }
        THIS = { NOT = { tag = KUK } }
        THIS = { NOT = { tag = DNB } }
        THIS = { NOT = { tag = UBD } }
        THIS = {
            culture_has_union_tag = yes
            nationalism_n_imperialism = 1
            is_greater_power = yes
            is_cultural_union = no
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            NOT = { is_culture_group = THIS }
            AND = {
                war_with = THIS
                is_culture_group = THIS
                #part_of_sphere = no
                THIS = { NOT = { tag = AUS } }
                THIS = { NOT = { tag = KUK } }
                THIS = { NOT = { tag = DNB } }
                THIS = { NOT = { tag = UBD } }
            }
        }
        number_of_states = 2
        any_state = {
            any_owned_province = {
                any_core = {
                    this_culture_union = this_union
                    is_cultural_union = yes
					NOT = {
					    tag = SIE
					    tag = BAN
					    tag = UBD
					    tag = VRP
				   }
                }
            }
            NOT = { any_owned_province = { is_capital = yes } }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }
    allowed_states = {
        any_owned_province = {
            any_core = {
                this_culture_union = this_union
                is_cultural_union = yes
                NOT = {
					tag = SIE
					tag = BAN
					tag = UBD
					tag = VRP
				}
            }
        }
        NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            THIS = { ai = no }
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
        }
    }

    po_demand_state = yes

    war_name = WAR_UNIFICATION_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

# Civil war
civil_war = {
    sprite_index = 2
    is_triggered_only = yes
    months = 1
    constructing_cb = no
    crisis = no

    can_use = {
        NOT = { is_our_vassal = THIS }
        always = no
    }

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 0.5
    break_truce_militancy_factor = 0.5
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    po_annex = yes

    war_name = CIVIL_WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

#Unification Annex
unification_annex_casus_belli = {
    sprite_index = 5
    is_triggered_only = no
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        is_vassal = no
        NOT = { is_our_vassal = THIS }
        THIS = {
            culture_has_union_tag = yes
            nationalism_n_imperialism = 1
            is_greater_power = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            NOT = { is_culture_group = THIS }
            AND = {
                war_with = THIS
                is_culture_group = THIS
                #part_of_sphere = no
                THIS = { NOT = { tag = AUS } }
                THIS = { NOT = { tag = KUK } }
                THIS = { NOT = { tag = DNB } }
                THIS = { NOT = { tag = UBD } }
            }
        }
        NOT = { number_of_states = 2 }
        any_owned_province = {
            any_core = {
                this_culture_union = this_union
                is_cultural_union = yes
				NOT = {
				    tag = SIE
				    tag = BAN
				    tag = UBD
				    tag = VRP
				}
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    po_annex = yes

    war_name = WAR_UNIFICATION_ANNEX_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

# Annex Core Country
annex_core_country = {
    sprite_index = 5
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.7
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        any_owned_province = { is_core = THIS }
        NOT = {
            any_owned_province = {
                NOT = { is_core = THIS }
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = neutrality_modifier } }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    po_annex = yes

    war_name = WAR_RESTORE_ORDER_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Sphere of Influence Gain
add_to_sphere = {
    sprite_index = 3
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 2
    prestige_factor = 2
    peace_cost_factor = 50
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        NOT = { total_pops = 11000000 }
        THIS = { is_greater_power = yes }
        is_greater_power = no
        is_vassal = no
        OR = {
            part_of_sphere = no
            war_with = THIS
        }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { war_policy = jingoism }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
        NOT = {
            AND = {
                THIS = {
                    ai = yes
                    nationalism_n_imperialism = 1
                }
                culture_has_union_tag = yes
                is_culture_group = THIS
                NOT = { is_cultural_union = THIS }
            }
        }
    }

    po_add_to_sphere = yes

    war_name = WAR_ADD_SPHERE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                owner = {
                    has_country_flag = surrender_sudan_on_lose
                }
            }
            owner = {
                clr_country_flag = surrender_sudan_on_lose
                any_owned = {
                    limit = {
                        OR = {
                            is_core = SUD
                            is_core = ETH
                        }
                    }
                    secede_province = THIS
                }
            }
        }
    }
}

# Unification Humiliate
unification_humiliate_cb = {
    sprite_index = 24
    is_triggered_only = no
    months = 12
    crisis = no

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 10
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        THIS = {
            culture_has_union_tag = yes
            nationalism_n_imperialism = 1
            is_greater_power = yes
            NOT = { tag = KUK }
            NOT = { tag = UBD }
            NOT = { tag = DNB }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        is_greater_power = yes
        is_culture_group = THIS
        cultural_union = { exists = no }
        has_cultural_sphere = yes
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
    }
    po_clear_union_sphere = yes

    tws_battle_factor = 2.0 # battle score twice that of oppenent

    war_name = UNIFICATION_HUMILIATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

# Unification GP Humiliate
unification_GP_humiliate = {
    sprite_index = 24
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 15
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    always = yes

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        NOT = { tag = KUK }
        NOT = { tag = UBD }
        NOT = { tag = DNB }
        culture_has_union_tag = yes
        is_culture_group = THIS
        is_greater_power = yes
        cultural_union = { exists = no }
        NOT = { has_cultural_sphere = yes }
        THIS = {
            ai = yes
            is_greater_power = yes
            nationalism_n_imperialism = 1
            NOT = { tag = KUK }
            NOT = { tag = UBD }
            NOT = { tag = DNB }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = -50 } }
        }
    }

    po_remove_prestige = yes

    tws_battle_factor = 2.0 # battle score twice that of oppenent

    war_name = UNIFICATION_HUMILIATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        prestige_factor = -0.2
    }
}

# Release Puppet
unification_release_puppet_cb = {
    sprite_index = 10
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 15
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        num_of_vassals_no_substates = 1
        THIS = {
            culture_has_union_tag = yes
            nationalism_n_imperialism = 1
            is_greater_power = yes
            NOT = { is_cultural_union = yes }
            NOT = { tag = KUK }
            NOT = { tag = UBD }
            NOT = { tag = DNB }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        NOT = {
            is_cultural_union = yes
            is_culture_group = THIS
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        is_our_vassal = FROM
        FROM = { is_culture_group = THIS is_substate = no }
        FROM = {
			NOT = {
				is_substate = yes
				has_country_flag = unreleasable_country
				tag = SIE
				tag = BAN
				tag = VRP
			}
		}
    }

    po_release_puppet = yes
    po_add_to_sphere = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Sphere of Influence Gain
unification_add_to_sphere = {
    sprite_index = 3
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 0.5

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 50
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    always = yes

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_greater_power = no
        is_vassal = no
        OR = {
            part_of_sphere = no
            war_with = THIS
        }
        culture_has_union_tag = yes
        is_culture_group = THIS
        cultural_union = { exists = no }
        NOT = {
			has_country_modifier = neutrality_modifier
			tag = SIE
			tag = BAN
			tag = UBD
			tag = VRP
		}
        THIS = {
            ai = yes
            is_greater_power = yes
            nationalism_n_imperialism = 1
            NOT = { tag = KUK }
            NOT = { tag = UBD }
            NOT = { tag = DNB }
            NOT = { has_country_modifier = no_more_war }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
    }

    po_add_to_sphere = yes

    war_name = WAR_ADD_SPHERE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

#Take from Sphere CB's
take_from_sphere = {
    sprite_index = 4
    is_triggered_only = yes
    months = 12

    badboy_factor = 2
    prestige_factor = 3
    peace_cost_factor = 20
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }

        THIS = { is_greater_power = yes }
        is_greater_power = yes
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = proletarian_dictatorship }
            THIS = { government = fascist_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        is_sphere_leader_of = FROM
        NOT = { is_our_vassal = FROM }
        OR = {
            FROM = { is_vassal = no }
            THIS = { is_our_vassal = FROM }
        }
        OR = {
            FROM = {
                capital_scope = { continent = africa }
                civilized = no
            }
            FROM = { is_secondary_power = yes }
            FROM = { neighbour = THIS }
            FROM = { is_culture_group = THIS }
            THIS = { war_policy = jingoism }
            THIS = { ai = no }
        }
        NOT = {
            AND = {
                THIS = {
                    ai = no
                    nationalism_n_imperialism = 1
                }
                FROM = {
                    culture_has_union_tag = yes
                    is_culture_group = THIS
                    cultural_union = { exists = no }
                    sphere_owner = { is_culture_group = THIS }
                }
            }
        }
    }

    po_add_to_sphere = yes

    war_name = WAR_TAKE_SPHERE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

#Free Peoples CB's
free_peoples = {
    sprite_index = 9
    is_triggered_only = yes
    months = 12

    badboy_factor = 1.5
    prestige_factor = 2
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
            any_neighbor_country = { OR = { vassal_of = THIS substate_of = THIS in_sphere = THIS } }
        }
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        number_of_states = 2
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
            FROM = { involved_in_crisis = yes }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            FROM = { involved_in_crisis = yes }
            THIS = { ai = no }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            FROM = { involved_in_crisis = yes }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        FROM = {
            OR = {
                NOT = { has_country_flag = unreleasable_country }
                exists = yes
            }
        }
        NOT = {
            FROM = { war_with = THIS }
            FROM = { is_substate = yes }
        }
        NOT = {
            tag = FROM
            FROM = { tag = THIS }
            FROM = { tag = MTC }
            FROM = { tag = ETH }
            this_culture_union = FROM
            AND = {
                FROM = { tag = ETH }
                ETH = { exists = no }
            }
            AND = {
                FROM = { tag = BOL }
                exists = PBC
            }
        }
        FROM = {
            OR = {
                exists = yes
                is_cultural_union = no
                involved_in_crisis = yes
            }
        }
        OR = {
            FROM = { civilized = yes }
            THIS = { civilized = no }
            FROM = { involved_in_crisis = yes }
            THIS = { ai = no }
        }
        OR = {
            THIS = { ai = no }
            FROM = { NOT = { any_core = { owned_by = THIS } } }
            FROM = { involved_in_crisis = yes }
        }
        OR = {
            FROM = { exists = no }
            FROM = { alliance_with = THIS }
            FROM = { in_sphere = THIS }
            FROM = { relation = { who = THIS value = 100 } }
            FROM = { involved_in_crisis = yes }
            AND = {
                tag = EGY
                THIS = { has_country_flag = oriental_crisis_support_OE }
                FROM = { tag = TUR }
            }
            THIS = { ai = no }
        }
        any_owned_province = {
            is_core = FROM
            NOT = { is_core = THIS }
        }
        OR = {
            THIS = { ai = no }
            FROM = { exists = yes }
            FROM = { involved_in_crisis = yes }
            FROM = {
                exists = no
                NOT = {
                    tag = CAT
                    tag = BSQ
                    tag = UKR
                    tag = KDS
                    tag = IRQ
                    tag = GEO
                }
            }
            AND = {
                owns = 498
                FROM = { tag = CAT }
            }
            AND = {
                owns = 492
                FROM = { tag = BSQ }
            }
            AND = {
                owns = 958
                FROM = { tag = UKR }
            }
            AND = {
                owns = 893
                FROM = { tag = KDS }
            }
            AND = {
                owns = 926
                FROM = { tag = IRQ }
            }
            AND = {
                owns = 1095
                FROM = { tag = GEO }
            }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        OR = {
            AND = {
                THIS = { ai = no }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                FROM = { exists = yes }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                FROM = { involved_in_crisis = yes }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = no }
                any_owned_province = {
                    is_core = FROM
                    OR = {
                        any_neighbor_province = { owned_by = THIS }
                        controlled_by = THIS
                    }
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                FROM = { NOT = { is_culture_group = THIS } }
                any_owned_province = {
                    is_core = FROM
                    OR = {
                        any_neighbor_province = { owned_by = THIS }
                        any_neighbor_province = {
                            owner = {
                                OR = {
                                    in_sphere = THIS
                                    alliance_with = THIS
                                }
                            }
                        }
                        controlled_by = THIS
                    }
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = europe } }
                any_owned_province = {
                    continent = europe
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = north_america } }
                any_owned_province = {
                    OR = {
                        continent = north_america
                        continent = south_america
                    }
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = south_america } }
                any_owned_province = {
                    OR = {
                        continent = north_america
                        continent = south_america
                    }
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = asia } }
                any_owned_province = {
                    continent = asia
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                FROM = { is_culture_group = THIS }
                any_owned_province = { is_core = FROM }
            }
        }
        OR = {
            THIS = { ai = no }
            FROM = { exists = yes }
            FROM = { involved_in_crisis = yes }
            FROM = {
                exists = no
                NOT = {
                    tag = POL
                    tag = HUN
                    tag = BOH
                    tag = ALB
                    tag = LIT
                    tag = BOS
                    tag = CRO
                    tag = BUL
                    tag = SIE
                    tag = LUX
                }
            }
            AND = {
                any_owned_province = {
                    OR = {
                        region = PRU_701
                        region = RUS_706
                        region = RUS_715
                        region = AUS_702
                    }
                }
                FROM = { tag = POL }
            }
            AND = {
                any_owned_province = {
                    OR = {
                        region = AUS_641
                        region = AUS_623
                    }
                }
                FROM = { tag = HUN }
            }
            AND = {
                any_owned_province = { region = AUS_771 }
                FROM = { tag = CRO }
            }
            AND = {
                any_owned_province = { region = TUR_810 }
                FROM = { tag = BUL }
            }
            AND = {
                any_owned_province = { region = AUS_625 }
                FROM = { tag = BOH }
            }
            AND = {
                any_owned_province = { region = TUR_853 }
                FROM = { tag = ALB }
            }
            AND = {
                any_owned_province = { region = TUR_788 }
                FROM = { tag = BOS }
            }
            AND = {
                any_owned_province = { region = RUS_360 }
                FROM = { tag = LIT }
            }
            AND = {
                any_owned_province = { region = AUS_657 }
                FROM = { tag = SIE }
            }
            AND = {
                any_owned_province = { province_id = 397 }
                FROM = { tag = LUX }
            }
        }
    }

    po_transfer_provinces = yes

    war_name = WAR_FREE_NAME

    on_add = {
        random_owned = {
            limit = { owner = { ai = no } }
            owner = { add_country_modifier = { name = disable_conquest_cb duration = -1 } }
        }
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        THIS = { remove_country_modifier = disable_conquest_cb }
        country_event =    2651    # Territorial Loss event
    }
}

# Liberate country
liberate_country = {
    sprite_index = 15
    is_triggered_only = yes
    months = 12

    badboy_factor = 2.2
    prestige_factor = 2
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1


    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
			AND = {
				THIS = { involved_in_crisis = yes }
				FROM = { involved_in_crisis = yes }
			}
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = {
            is_our_vassal = THIS
            has_country_modifier = neutrality_modifier
        }
        is_vassal = no
        number_of_states = 2
        OR = {
            war_with = THIS
			THIS = { involved_in_crisis = yes }
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
            FROM = { involved_in_crisis = yes }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            FROM = { involved_in_crisis = yes }
            THIS = { ai = no }
            has_global_flag = italy_fights_turk
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            FROM = { involved_in_crisis = yes }
            THIS = { ai = no }
            has_global_flag = italy_fights_turk
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        #Prevent the CB being used on substates and on countries you are at war with
        NOT = {
            FROM = { war_with = THIS }
            FROM = { is_substate = yes }
        }

        FROM = {
            OR = {
                NOT = { has_country_flag = unreleasable_country }
                exists = yes
            }
        }

        OR = {
            is_releasable_vassal = FROM
            FROM = { exists = yes }
            FROM = { involved_in_crisis = yes }
        }
        OR = {
            THIS = { ai = no }
            FROM = { NOT = { any_core = { is_core = THIS } } }
            FROM = { involved_in_crisis = yes }
        }
        NOT = {
            tag = FROM
            FROM = { tag = THIS }
            FROM = { tag = MTC }
            this_culture_union = FROM
            AND = {
                FROM = { tag = ETH }
                NOT = { exists = ETH }
            }
            AND = {
                FROM = { tag = BOL }
                exists = PBC
            }
        }
        OR = {
			AND = {
                THIS = { ai = yes }
                war_countries = { any_owned_province = { is_core = FROM } }
            }
            AND = {
                THIS = { ai = no }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                FROM = { exists = yes }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                FROM = { involved_in_crisis = yes }
                any_owned_province = { is_core = FROM }
            }
            AND = {
                involved_in_crisis = yes
                any_owned_province = {
                    is_core = FROM
                    NOT = { is_core = THIS }
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = no }
                any_owned_province = {
                    is_core = FROM
                    OR = {
                        any_neighbor_province = { owned_by = THIS }
                        controlled_by = THIS
                    }
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                FROM = { NOT = { is_culture_group = THIS } }
                any_owned_province = {
                    is_core = FROM
                    OR = {
                        any_neighbor_province = { owned_by = THIS }
                        any_neighbor_province = {
                            owner = {
                                OR = {
                                    in_sphere = THIS
                                    alliance_with = THIS
                                }
                            }
                        }
                        controlled_by = THIS
                    }
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = europe } }
                any_owned_province = {
                    continent = europe
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = north_america } }
                any_owned_province = {
                    OR = {
                        continent = north_america
                        continent = south_america
                    }
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = south_america } }
                any_owned_province = {
                    OR = {
                        continent = north_america
                        continent = south_america
                    }
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = asia } }
                any_owned_province = {
                    continent = asia
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = africa } }
                any_owned_province = {
                    continent = africa
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = oceania } }
                any_owned_province = {
                    continent = oceania
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = australia_new_zealand } }
                any_owned_province = {
                    continent = australia_new_zealand
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                THIS = { capital_scope = { continent = polynesia } }
                any_owned_province = {
                    continent = polynesia
                    is_core = FROM
                }
            }
            AND = {
                FROM = { exists = no }
                THIS = { civilized = yes }
                FROM = { is_culture_group = THIS }
                any_owned_province = { is_core = FROM }
            }
        }
        FROM = {
            OR = {
                exists = yes
                is_cultural_union = no
                involved_in_crisis = yes
            }
        }
        OR = {
            FROM = { involved_in_crisis = yes }
            FROM = { civilized = yes }
            THIS = { civilized = no }
            THIS = { ai = no }
        }
        OR = {
            FROM = { exists = no }
            FROM = { alliance_with = THIS }
            FROM = { in_sphere = THIS }
            FROM = { relation = { who = THIS value = 100 } }
            FROM = { involved_in_crisis = yes }
            AND = {
                tag = EGY
                THIS = { has_country_flag = oriental_crisis_support_OE }
                FROM = { tag = TUR }
            }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        any_owned_province = { is_core = FROM }
    }
    all_allowed_states = yes
    po_transfer_provinces = yes

    war_name = WAR_LIBERATE_NAME

    on_add = {
        random_owned = {
            limit = { owner = { ai = no } }
            owner = { add_country_modifier = { name = disable_conquest_cb duration = -1 } }
        }
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        THIS = { remove_country_modifier = disable_conquest_cb }
        country_event =    2651    # Territorial Loss event
        random_owned = {
            limit = { owner = { tag = TUR has_global_flag = italy_fights_turk war_with = ITA } }
            ITA = { country_event = 900009 }
        }
    }
}

free_allied_cores = {
    sprite_index = 25
    is_triggered_only = yes
    months = 12

    construction_speed = 0.75

    badboy_factor = 0.75
    prestige_factor = 2
    peace_cost_factor = 0.8
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        number_of_states = 2
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        any_owned_province = { is_core = FROM }
        NOT = {
            tag = FROM
            is_our_vassal = FROM
        }
        OR = {
            NOT = { alliance_with = FROM }
            war_with = THIS
        }
        OR = {
            FROM = { alliance_with = THIS }
            war_with = THIS
        }
        FROM = {
            exists = yes
            in_sphere = THIS
            NOT = {
                any_core = { owned_by = THIS }
            }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        #NOT = { any_owned_province = { is_capital = yes } }
        NOT = { any_owned_province = { is_core = THIS } }
        any_owned_province = { is_core = FROM }
    }

    po_transfer_provinces = yes

    war_name = WAR_FREE_ALLIED_CORE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event =    2651    # Territorial Loss event
    }
}

free_balkans = {
    sprite_index = 25
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 0.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        number_of_states = 2
        tag = TUR
        any_owned_province = {
            OR = {
                is_core = GRE
                is_core = SER
                is_core = ROM
                is_core = MON
                is_core = BUL
                AND = {
                    is_core = BOS
                    THIS = { has_country_flag = oe_refused_congress }
                }
                AND = {
                    is_core = ALB
                    THIS = { has_country_flag = oe_refused_congress }
                }
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = no_more_war }
            }
        }
        THIS = {
            OR = {
                has_country_modifier = protector_of_eastern_christendom
                AND = {
                    OR = {
                        is_culture_group = east_slavic
                        is_culture_group = south_slavic
                        is_culture_group = pan_romanian
                    }
                    has_global_flag = balkans_call_for_help
                }
                AND = {
                    is_greater_power = yes
                    has_country_flag = oe_refused_congress
                }
            }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        FROM = {
            OR = {
                tag = GRE
                tag = SER
                tag = ROM
                tag = MOL
                tag = WAL
                tag = MON
                tag = BUL
                AND = {
                    tag = BOS
                    THIS = { has_country_flag = oe_refused_congress }
                }
                AND = {
                    tag = ALB
                    THIS = { has_country_flag = oe_refused_congress }
                }
            }
            OR = {
                exists = yes
                is_cultural_union = no
            }
            NOT = { vassal_of = TUR }
        }
        FROM = {
            OR = {
                exists = no
                relation = { who = THIS value = 100 }
                in_sphere = THIS
                alliance_with = THIS
            }
        }
        any_owned_province = {
            is_core = FROM
            NOT = { is_core = THIS }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        any_owned_province = {
            is_core = FROM
            NOT = { is_core = THIS }
        }
    }

    all_allowed_states = yes
    po_transfer_provinces = yes
    po_remove_cores = yes

    war_name = WAR_FREE_BALKANS_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

monroe_doctrine = {
    sprite_index = 19
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 1.0

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 0.5
    penalty_factor = 0.5

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48
    always = yes

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        THIS = {
            tag = USA
            government = democracy
            is_greater_power = yes
        }
        is_vassal = no
        OR = {
            capital_scope = { continent = europe }
            capital_scope = { continent = africa }
            capital_scope = { continent = asia }
            capital_scope = { continent = oceania }
            capital_scope = { continent = australia_new_zealand }
            capital_scope = { continent = polynesia }
        }
        any_owned_province = {
            OR = {
                continent = south_america
                continent = north_america
            }
            any_core = {
                OR = {
                    primary_culture = mexican
                    primary_culture = central_american
                    primary_culture = north_andean
                    primary_culture = south_andean
                    primary_culture = platinean
                    primary_culture = brazilian
                    primary_culture = mayan
                    AND = {
                        tag = CUB
                        USA = { has_country_flag = maine_incident }
                    }
                }
            }
            NOT = {
                is_core = USA
                region = ENG_1979 #Guayana
                #region = ARG_2391 Patagonia Septentrional
                #region = CHL_2332 Araucania
                region = ENG_2132
                #region = NET_2235
                #region = ARG_2398 Patagonia Meridional
                province_id = 2131 #Falkland's
                province_id = 2190
                province_id = 2200
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        NOT = { tag = FROM }
        any_owned_province = {
            is_core = FROM
            NOT = { is_core = USA }
        }
        FROM = {
            OR = {
                primary_culture = mexican
                primary_culture = central_american
                primary_culture = north_andean
                primary_culture = south_andean
                primary_culture = platinean
                primary_culture = brazilian
                primary_culture = mayan
                AND = {
                    tag = CUB
                    USA = { has_country_flag = maine_incident }
                }
            }
            OR = {
                exists = yes
                is_cultural_union = no
            }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        any_owned_province = {
            is_core = FROM
            OR = {
                continent = north_america
                continent = south_america
            }
        }
        NOT = {
            any_owned_province = {
                OR = {
                    is_core = USA
                    region = ENG_1979 #Guayana
                    #region = ARG_2391 Patagonia Septentrional
                    #region = CHL_2332 Araucania
                    region = ENG_2132
                    #region = NET_2235
                    #region = ARG_2398 Patagonia Meridional
                    province_id = 2131 #Falkland's
                    province_id = 2190
                    province_id = 2200
                }
            }
        }
    }

    po_transfer_provinces = yes

    war_name = WAR_MONROE_DOCTRINE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

oriental_crisis = {
    sprite_index = 26
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        number_of_states = 2
        tag = EGY
        civilized = no
        has_global_flag = oriental_crisis
        any_owned_province = { is_core = TUR }
        NOT = { has_country_modifier = neutrality_modifier }
        NOT = { year = 1860 }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        THIS = {
            has_country_flag = oriental_crisis_support_OE
            NOT = { truce_with = TUR }
            OR = {
                alliance_with = TUR
                relation = { who = TUR value = 50 }
            }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        FROM = { tag = TUR }
        any_owned_province = {
            is_core = FROM
            NOT = { is_core = THIS }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        any_owned_province = { is_core = FROM }
        #not = { any_owned_province = { is_capital = yes } } #code can deal with capitals they get new state
    }

    po_transfer_provinces = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

#Release Puppet CB's
release_puppet = {
    sprite_index = 30
    is_triggered_only = yes
    months = 12

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        num_of_vassals_no_substates = 1
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = neutrality_modifier } }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        is_our_vassal = FROM
        FROM = {
            is_substate = no
            NOT = { has_country_flag = unreleasable_country }
        }
    }

    po_release_puppet = yes
    po_add_to_sphere = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

release_puppet_AI = {
    sprite_index = 30
    is_triggered_only = yes
    months = 12

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        num_of_vassals_no_substates = 1
        OR = {
            war_with = THIS
            NOT = {
                relation = {
                    who = THIS
                    value = -100
                }
            }
        }
        THIS = {
            ai = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = no_more_war }
            }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        is_our_vassal = FROM
        FROM = {
            is_substate = no
            OR = {
                neighbour = THIS
                any_owned_province = { controlled_by = THIS }
            }
        }
    }

    po_release_puppet = yes
    po_add_to_sphere = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

#Gunboat CB
gunboat = {
    sprite_index = 27
    is_triggered_only = yes
    months = 12
    constructing_cb = no
    crisis = no

    badboy_factor = 1
    prestige_factor = 5
    peace_cost_factor = 1
    penalty_factor = 0

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        OR = {
            has_country_modifier = in_bankrupcy
            has_country_modifier = generalised_debt_default
        }
        THIS = {
            is_greater_power = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
        is_vassal = no
        in_default = THIS
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            war_with = THIS
            NOT = { relation = { who = THIS value = 50 } }
            THIS = { ai = no }
        }
    }

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    po_gunboat = yes

    war_name = WAR_GUNBOAT_NAME
}

# Cut Down to size
cut_down_to_size = {
    sprite_index = 8
    is_triggered_only = yes
    months = 12

    badboy_factor = 1.3
    prestige_factor = 1
    peace_cost_factor = 25
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    po_disarmament = yes
    po_reparations = yes

    war_name = CUT_DOWN_TO_SIZE_WAR_NAME

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
            any_neighbor_country = { OR = { vassal_of = THIS substate_of = THIS in_sphere = THIS } }
        }
        is_vassal = no
        is_disarmed = no
        NOT = { has_country_modifier = neutrality_modifier }
        THIS = { civilized = yes }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }

        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                owner = {
                    civilized = no
                    OR = {
                        owns = 1498 #Macao
                        owns = 1538 #Shanghai
                        owns = 1496 #Hong Kong
                        owns = 1566    #Qingdao
                        owns = 1481 #Lushun - Port Arthur
                        owns = 1569 #Weihaiwei
                        owns = 1606 #Jiaxing
                        owns = 2681 #Taibei
                        owns = 2562 #Tainan
                        owns = 1499 #Hainan
                        owns = 2632 #Kwangchowan
                        #owns = 1540 #Nantong
                        owns = 1071 #Qeshm
                        owns = 1695 #Ifni
                    }
                }
                THIS = {
                    civilized = yes
                    NOT = { is_culture_group = east_asian }
                    any_owned_province = { port = yes }
                }
            }
            owner = { add_country_modifier = { name = negotiating_unequal_treaty duration = 30 } }
            THIS = { add_country_modifier = { name = negotiating_treaty duration = 30 } }
        }
        random_owned = { limit = { owner = { civilized = no has_country_modifier = uncivilized_isolationism } }
            owner = { remove_country_modifier = uncivilized_isolationism }
        }
        random_owned = { limit = { owner = { civilized = no NOT = { has_country_modifier = western_influences } } }
            owner = { add_country_modifier = { name = western_influences duration = -1 } }
        }
        random_owned = { limit = { owner = { civilized = no NOT = { capital_scope = { has_country_modifier = legation_quarter } } } }
            owner = { capital_scope = { add_province_modifier = { name = legation_quarter duration = -1 } } }
        }
        random_owned = { limit = { owner = { has_country_flag = holding_tangiers owns = 1686 } }
            owner = { 1686 = { secede_province = THIS } clr_country_flag = holding_tangiers }
            THIS = { 1686 = { secede_province = MOR } }
        }
        random_owned = { limit = { owner = { has_country_flag = refused_to_cede_congo } }
            owner = { any_owned = { limit = { is_core = CNG } secede_province = THIS } clr_country_flag = refused_to_cede_congo }
            THIS = { any_owned = { limit = { is_core = CNG } secede_province = CNG } }
        }

        random_owned = {
            limit = {
                owner = { has_country_flag = lied_about_congo }
                THIS = { has_country_flag = claiming_congo }
            }
            owner = {
                any_country = { clr_country_flag = claiming_congo }
                clr_country_flag = lied_about_congo
                any_owned = {
                    limit = { is_core = CNG }
                    secede_province = THIS
                }
            }
        }

    }
}

great_game_cb = {
    sprite_index = 22
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 0.8

    badboy_factor = 1
    prestige_factor = 2
    peace_cost_factor = 0.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    po_make_puppet = yes

    war_name = WAR_PUPPET_NAME

    can_use = {
        is_vassal = no
        civilized = no
        NOT = {
            has_global_flag = british_dismantled
            is_our_vassal = THIS
            truce_with = THIS
        }
        OR = {
            neighbour = THIS
            any_neighbor_country = { vassal_of = THIS }
        }
        OR = {
            tag = SIN
            tag = KAL
            tag = MAK
            tag = AFG
            tag = KAS
            tag = KOK
            tag = KHI
            tag = BUK
            tag = CRL
            tag = KAZ
            tag = BDK
            AND = {
                tag = PNJ
                has_country_flag = ranjit_singh_dead
            }
        }
        ENG = { is_greater_power = yes }
        RUS = { is_greater_power = yes }
        THIS = {
            OR = {
                tag = ENG
                tag = RUS
            }
            OR = {
                government = absolute_monarchy
                government = prussian_constitutionalism
                government = hms_government
            }
            NOT = {
                has_country_flag = no_more_great_game
                has_country_modifier = punitive_effects
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
    }

    on_add = {
        random_country = {
            limit = {
                OR = {
                    tag = RUS
                    tag = ENG
                }
                NOT = { tag = THIS }
            }
            relation = { who = THIS value = -50 }
        }
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event = 19370
    }
}

restore_british_raj = {
    sprite_index = 10
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 0.8
    penalty_factor = 2

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    po_make_puppet = yes

    war_name = WAR_BRITISH_RAJ_NAME

    can_use = {
        is_vassal = no
        is_disarmed = no
        civilized = no
        NOT = {
            is_our_vassal = THIS
            truce_with = THIS
            tag = HND
            has_country_modifier = neutrality_modifier
            has_global_flag = british_dismantled
        }
        OR = {
            tag = ASM
            tag = AWA
            tag = BAS
            tag = BER
            tag = BIH
            tag = BIK
            tag = BHO
            tag = BNG
            tag = BUN
            tag = IND
            tag = JAI
            tag = JAS
            tag = JOD
            tag = MAH
            tag = MEW
            tag = MUG
            tag = MYS
            tag = NAG
            tag = ORI
            tag = TRA
            tag = KUT
        }
        THIS = {
            tag = ENG
            OR = {
                government = absolute_monarchy
                government = prussian_constitutionalism
                government = hms_government
            }
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = {
                    has_country_modifier = no_more_war
                }
            }
        }
    }

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event = 19370
    }
}

# Humiliate
humiliate = {
    sprite_index = 11
    is_triggered_only = yes
    months = 12

    badboy_factor = 1.5
    prestige_factor = 1
    peace_cost_factor = 15
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        has_recently_lost_war = no
        OR = {
            war_with = THIS
            THIS = {
                military_score = 1
                NOT = { has_country_modifier = neutrality_modifier }
            }
        }
        NOT = {
            AND = {
                has_country_modifier = neutrality_modifier
                is_greater_power = no
            }
        }
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
        OR = {
            AND = {
                prestige = 10
                has_recently_lost_war = no
            }
            THIS = { ai = no }
        }
        OR = {
            neighbour = THIS
            THIS = { is_greater_power = yes }
            THIS = { ai = no }
        }
        #AI GP's will not invoke Humiliate when they have Unification Humiliate available
        NOT = {
            AND = {
                culture_has_union_tag = yes
                is_culture_group = THIS
                is_greater_power = yes
                cultural_union = { exists = no }
                NOT = { has_cultural_sphere = yes }
                THIS = {
                    ai = yes
                    is_greater_power = yes
                    nationalism_n_imperialism = 1
                }
            }
        }
    }

    po_remove_prestige = yes

    tws_battle_factor = 2.0

    war_name = WAR_HUMILIATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        prestige_factor = -0.2
    }
}

#Acquire colonial state CB's
place_in_the_sun = {
    sprite_index = 7
    is_triggered_only = yes
    months = 12

    badboy_factor = 1.1
    prestige_factor = 2
    peace_cost_factor = 0.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        any_owned_province = { is_colonial = yes }
        THIS = {
            NOT = { has_country_modifier = neutrality_modifier }
            OR = {
                any_owned_province = { port = yes }
                any_owned_province = {
                    any_neighbor_province = {
                        NOT = { owned_by = THIS }
                        is_colonial = yes
                    }
                }
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        #AI Pacifist will not use this
        OR = {
            THIS = { ai = no }
            THIS = { NOT = { war_policy = pacifism } }
            war_with = THIS
        }
        #AI Anti Military will not use this commonly
        OR = {
            THIS = { ai = no }
            THIS = { NOT = { war_policy = anti_military } }
            NOT = { relation = { who = THIS value = -50 } }
            war_with = THIS
        }
        #AI after the Berlin Conference will need to hate each other guts to use this
        OR = {
            THIS = { ai = no }
            NOT = { has_global_flag = berlin_conference }
            NOT = { relation = { who = THIS value = -100 } }
            war_with = THIS
        }

        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
    }

    allowed_states = {
        any_owned_province = { is_colonial = yes }
        OR = {
            any_owned_province = {
                NOT = {
                    OR = {
                        any_core = { exists = yes }
                        any_core = { exists = no }
                    }
                }
            }
            any_owned_province = {
                any_core = { civilized = no }
            }
            any_owned_province = { continent = africa }
            THIS = { ai = no }
        }
        ###Can only grab neighboring states, coastal if it's a coastal GP
        OR = {
            #AI and Player can take a neighboring state
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            #Player can take a neighboring state neighboring a neighboring state
            AND = {
                THIS = { ai = no }
                any_owned_province = {
                    any_neighbor_province = {
                        state_scope = { any_owned_province = { any_neighbor_province = { owned_by = THIS } } }
                    }
                }
            }

            #AI/Player can take a coastal state
            AND = {
                any_owned_province = { port = yes }
                THIS = {
                    any_owned_province = { port = yes }
                    OR = {
                        is_greater_power = yes
                        is_secondary_power = yes
                        ai = no
                    }
                }
            }

            #Player can take any state neighboring a coastal state
            AND = {
                any_owned_province = {
                    any_neighbor_province = {
                        state_scope = { any_owned_province = { port = yes } }
                    }
                }
                THIS = {
                    ai = no
                    any_owned_province = { port = yes }
                }
            }
        }
        # #AI countries will avoid taking new world colonies (e.g. from Argentina) when not proper
        # OR = {
            # THIS = { ai = no }
            # THIS = {
                # capital_scope = {
                    # NOT = {
                        # continent = europe
                        # continent = asia
                        # continent = africa
                    # }
                # }
            # }
            # any_owned_province = {
                # NOT = {
                    # continent = north_america
                    # continent = south_america
                # }
            # }
            # any_owned_province = { NOT = { any_core = { has_country_flag = new_world_nation } } }
            # any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            # any_owned_province = { terrain = new_world_small_island }
            # any_owned_province = { terrain = new_world_arctic }
            # any_owned_province = {
                # OR = {
                    # is_core = CUB
                    # is_core = HAI
                    # is_core = DOM
                    # is_core = CAN
                # }
            # }

        # }
    }

    allowed_states_in_crisis = {
        any_owned_province = {
            OR = {
                port = yes
                any_neighbor_province = { owner = { tag = THIS } }
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_COLONIAL_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Gain control of State
acquire_state = {
    sprite_index = 6
    is_triggered_only = yes
    months = 12

    construction_speed = 0.5

    badboy_factor = 2.2
    prestige_factor = 2
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        is_vassal = no
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
        }
        NOT = {
            is_our_vassal = THIS
            has_country_modifier = neutrality_modifier
        }
        any_state = {
            is_colonial = no
            NOT = { any_owned_province = { is_capital = yes } }
        }
        OR = {
            THIS = { civilized = no }
            civilized = yes
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
        #AI anti military will not use this
        OR = {
            THIS = { ai = no }
            THIS = { NOT = { war_policy = anti_military } }
            war_with = THIS
        }
        #AI will not use this CB when duking it out over hegemony
        OR = {
            THIS = { ai = no }
            NOT = {
                AND = {
                    culture_has_union_tag = yes
                    is_culture_group = THIS
                    cultural_union = { exists = no }
                    is_greater_power = yes
                    THIS = { is_greater_power = yes }
                }
            }
        }
    }

    allowed_states = {
        #Countries can't take capitals or cores
        NOT = {
            any_owned_province = { is_core = THIS }
            any_owned_province = { is_capital = yes }
        }

        #AI treats colonial states with only civilized cores as regular states
        OR = {
            is_colonial = no
            AND = {
                is_colonial = yes
                THIS = { ai = yes }
                any_owned_province = { any_core = { civilized = yes } }
                NOT = { any_owned_province = { any_core = { civilized = no } } }
            }
        }

        ###Can only grab neighboring states, coastal if it's a coastal GP
        OR = {
            #AI and Player can take a neighboring state
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            #Player can take a neighboring state neighboring a neighboring state
            AND = {
                THIS = { ai = no }
                any_owned_province = {
                    any_neighbor_province = {
                        state_scope = { any_owned_province = { any_neighbor_province = { owned_by = THIS } } }
                    }
                }
            }

            #AI/Player can take a coastal state
            AND = {
                any_owned_province = { port = yes }
                THIS = {
                    any_owned_province = { port = yes }
                    OR = {
                        is_greater_power = yes
                        is_secondary_power = yes
                        ai = no
                    }
                }
            }

            #Player can take any state neighboring a coastal state
            AND = {
                any_owned_province = {
                    any_neighbor_province = {
                        state_scope = { any_owned_province = { port = yes } }
                    }
                }
                THIS = {
                    ai = no
                    any_owned_province = { port = yes }
                }
            }
        }

        #AI will not grab cores of allies/spherelings
        OR = {
            THIS = { ai = no }
            NOT = {
                any_owned_province = {
                    any_core = {
                        exists = yes
                        OR = {
                            alliance_with = THIS
                            in_sphere = THIS
                            vassal_of = THIS
                        }
                    }
                }
            }
        }

        #AI will not try to grab cores of their union if they're sphere to a GP of their culture group
        OR = {
            THIS = { ai = no }
            NOT = {
                AND = {
                    THIS = {
                        is_greater_power = no
                        part_of_sphere = yes
                        culture_has_union_tag = yes
                        cultural_union = { exists = no }
                        sphere_owner = { is_culture_group = THIS }
                    }
                    any_owned_province = {
                        any_core = {
                            is_cultural_union = yes
                            this_culture_union = this_union
                        }
                    }
                }
            }
        }

        #pro-military AI will not grab cores of non-existing, non-union countries
        #unless they own some cores or it's part of their culture group and they're pro-military
        #jingoistic countries will also take states with existing cores that they also own some of
        #fascist & communist countries are exempt from this
        OR = {
            THIS = { ai = no }
            THIS = { government = proletarian_dictatorship }
            THIS = { government = fascist_dictatorship }
            AND = {
                THIS = { war_policy = pro_military }
                any_owned_province = {
                    any_core = {
                        is_cultural_union = no
                        exists = no
                        OR = {
                            any_core = { owned_by = THIS }
                            is_culture_group = THIS
                        }
                    }
                }
            }
            AND = {
                THIS = { war_policy = jingoism }
                any_owned_province = {
                    any_core = {
                        OR = {
                            any_core = { owned_by = THIS }
                            AND = {
                                exists = no
                                is_cultural_union = no
                                is_culture_group = THIS
                            }
                        }
                    }
                }
            }
        }
    }

    allowed_states_in_crisis = {
        NOT = { any_owned_province = { is_capital = yes } }
        any_owned_province = {
            OR = {
                port = yes
                any_neighbor_province = { owner = { tag = THIS } }
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_TAKE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Chinese Reunification
china_acquire_state = {
    sprite_index = 22
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 0
    break_truce_militancy_factor = 0
    truce_months = 84

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        neighbour = THIS
        OR = {
            any_owned_province = {
                NOT = { is_core = THIS }
                is_core = CHI
            }
            is_culture_group = east_asian
        }
        THIS = {
            NOT = { tag = LAN }
            is_culture_group = east_asian
            NOT = {
                has_country_modifier = neutrality_modifier
                war_policy = pacifism
            }
        }
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            NOT = { has_global_flag = warlord_era_has_begun }
            owns = 1616
            NOT = { is_culture_group = east_asian }
            AND = {
                tag = CHI
                THIS = { NOT = { has_country_flag = neutral_faction } }
                THIS = { NOT = { has_country_flag = kuomintang_faction } }
            }
            AND = {
                tag = TPG
                THIS = { NOT = { has_country_flag = neutral_faction } }
            }
            AND = {
                tag = KMT
                THIS = { NOT = { has_country_flag = neutral_faction } }
                THIS = { NOT = { has_country_flag = beiyang_faction } }
                THIS = { NOT = { has_country_flag = communist_faction } }
            }
            AND = {
                THIS = { tag = TPG }
                OR = {
                    has_country_flag = beiyang_faction
                    has_country_flag = kuomintang_faction
                    has_country_flag = communist_faction
                    tag = KMT
                    THIS = { NOT = { any_neighbor_country = { OR = { has_country_flag = beiyang_faction has_country_flag = kuomintang_faction has_country_flag = communist_faction tag = CHI tag = KMT } } } }
                }
            }
            AND = {
                THIS = { tag = KMT }
                OR = {
                    has_country_flag = beiyang_faction
                    tag = CHI
                    THIS = { NOT = { any_neighbor_country = { OR = { has_country_flag = beiyang_faction tag = CHI tag = TPG } } } }
                }
            }
            AND = {
                THIS = { has_country_flag = beiyang_faction }
                OR = {
                    has_country_flag = beiyang_faction
                    THIS = { NOT = { any_neighbor_country = { OR = { has_country_flag = beiyang_faction tag = CHI tag = TPG } } } }
                }
            }
            AND = {
                THIS = { has_country_flag = kuomintang_faction }
                OR = {
                    has_country_flag = kuomintang_faction
                    THIS = { NOT = { any_neighbor_country = { OR = { has_country_flag = kuomintang_faction tag = TPG tag = KMT } } } }
                }
            }
            AND = {
                THIS = { has_country_flag = communist_faction }
                OR = {
                    has_country_flag = communist_faction
                    THIS = { NOT = { any_neighbor_country = { OR = { has_country_flag = communist_faction tag = TPG tag = CHI } } } }
                }
            }
        }
    }

    allowed_states = {
        OR = {
            any_owned_province = {
                NOT = {    is_core = THIS }
                is_core = CHI
            }
            any_owned_province = {
                owner = { is_culture_group = east_asian }
                NOT = { is_core = CHI }
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_CHINA_REUNIFICATION

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.10
        }
    }
}

sahel_jihad_cb = {
    sprite_index = 29
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 1.25

    badboy_factor = 2
    prestige_factor = 2
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 0
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            AND = { war_with = THIS ai = no }
            neighbour = THIS
        }
        is_vassal = no
        civilized = no
        NOT = { is_our_vassal = THIS }
        any_owned_province = {
            OR = {
                province_id = 1786
                province_id = 1789
                province_id = 1794
                province_id = 1800
                province_id = 1804
                province_id = 1808
                province_id = 1878
                province_id = 1880
            }
        }
        NOT = { has_country_flag = sunni_country }
        THIS = {
            civilized = no
            OR = {
                government = theocracy
                government = absolute_monarchy
            }
            primary_culture = fulbe
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
    }

    allowed_states = {
        NOT = { any_owned_province = { is_core = THIS } }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
			THIS = { ai = no }
        }
    }

    po_demand_state = yes

    war_name = WAR_SAHEL_JIHAD_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Demand Concession
demand_concession_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    construction_speed = 1.2
    crisis = no

    badboy_factor = 1.5
    prestige_factor = 1
    peace_cost_factor = 0.6
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_modifier = neutrality_modifier }
        civilized = no
        number_of_states = 2
        is_vassal = no

        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            AND = { war_with = THIS ai = no }
            neighbour = THIS
        }
        THIS = {
            civilized = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            THIS = { NOT = { nationalism_n_imperialism = 1 } }
            NOT = { has_global_flag = berlin_conference }
            civilization_progress = 0.6
            has_country_flag = post_colonial_country
        }
        OR = {
            THIS = { NOT = { nationalism_n_imperialism = 1 } }
            AND = {
                THIS = { nationalism_n_imperialism = 1 }
                capital_scope = { continent = africa }
            }
            civilization_progress = 0.6
            has_country_flag = post_colonial_country
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }

        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }

        OR = {
            THIS = { war_policy = jingoism }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
    }

    allowed_states = {
        any_owned_province = { is_colonial = no }

        NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            THIS = { ai = no }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        OR = {
            any_owned_province = {
                NOT = {
                    any_core = {
                        exists = yes
                        alliance_with = THIS
                    }
                }
            }
            THIS = { ai = no }
        }

        #Restrictions to non-African State conquering
        OR = {
            continent = africa

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
                THIS = { machine_guns = 1 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
                THIS = {
                    bolt_action_rifles = 1
                    army_risk_management = 1
                }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
						modern_naval_doctrine = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
                THIS = {
                    modern_divisional_structure = 1
                    army_nco_training = 1
                }
				OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        invention = modern_battleships
						modern_naval_doctrine = 1
                    }
                }
            }
        } ###End of Non-African Restrictions

    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = {
    }
}

demand_concession_NI_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 1.2

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 0.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            AND = { war_with = THIS ai = no }
        }
        NOT = { is_our_vassal = THIS }
        THIS = {
            civilized = yes
            nationalism_n_imperialism = 1
            NOT = {
                has_country_modifier = neutrality_modifier
                has_global_flag = berlin_conference
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            NOT = {
                civilization_progress = 0.6
                has_country_flag = post_colonial_country
            }
            AND = {
                tag = KOR
                THIS = { tag = JAP }
            }
        }
        NOT = {
            has_country_modifier = neutrality_modifier
            capital_scope = { continent = africa }
        }
        civilized = no
        number_of_states = 2
        is_vassal = no

        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }

        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        any_owned_province = { is_colonial = no }

        NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
           THIS = { ai = no }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        OR = {
            any_owned_province = {
                NOT = {
                    any_core = {
                        exists = yes
                        alliance_with = THIS
                    }
                }
            }
            THIS = { ai = no }
        }

        #Restrictions to non-African State conquering
        OR = {
            continent = africa

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
                THIS = { machine_guns = 1 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
                THIS = {
                    bolt_action_rifles = 1
                    army_risk_management = 1
                }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
						modern_naval_doctrine = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
                THIS = {
                    modern_divisional_structure = 1
                    army_nco_training = 1
                }
				OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        invention = modern_battleships
						modern_naval_doctrine = 1
                    }
                }
            }
        } ###End of Non-African Restrictions

    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = {
    }
}

demand_concession_BC_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 1.2

    badboy_factor = 0.5
    prestige_factor = 1
    peace_cost_factor = 0.4
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            AND = { war_with = THIS ai = no }
        }
        NOT = { is_our_vassal = THIS }
        THIS = {
            civilized = yes
            nationalism_n_imperialism = 1
            has_global_flag = berlin_conference
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            NOT = {
                has_country_modifier = neutrality_modifier
                civilization_progress = 0.6
                has_country_flag = post_colonial_country
            }
            AND = {
                tag = KOR
                THIS = { tag = JAP }
            }
        }
        civilized = no
        number_of_states = 2
        is_vassal = no
        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }

        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        any_owned_province = { is_colonial = no }

        NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            THIS = { ai = no }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        OR = {
            any_owned_province = {
                NOT = {
                    any_core = {
                        exists = yes
                        alliance_with = THIS
                    }
                }
            }
            THIS = { ai = no }
        }

        #Restrictions to non-African State conquering
        OR = {
            continent = africa

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
                THIS = { machine_guns = 1 }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
                THIS = {
                    bolt_action_rifles = 1
                    army_risk_management = 1
                }
                OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
						modern_naval_doctrine = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
                THIS = {
                    modern_divisional_structure = 1
                    army_nco_training = 1
                }
				OR = {
                    any_owned_province = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        invention = modern_battleships
						modern_naval_doctrine = 1
                    }
                }
            }
        } ###End of Non-African Restrictions

    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = {
    }
}

# Bad Boy
rude_boy = {
    sprite_index = 28
    is_triggered_only = no
    months = 12
    construction_speed = 2
    crisis = no

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 1.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        badboy = 1
        is_disarmed = no
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }

        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    po_remove_prestige = yes
    po_disarmament = yes
    po_reparations = yes

    war_name = WAR_RUDEBOI_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

# Conquest
conquest = {
    sprite_index = 2
    is_triggered_only = yes
    months = 12
    crisis = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            AND = { war_with = THIS ai = no }
        }
        OR = {
            THIS = { civilized = no }
            civilized = yes
        }
        OR = {
            NOT = {
                any_state = {
                    is_colonial = no
                    NOT = { any_owned_province = { is_capital = yes } }
                }
            }
            AND = {
                THIS = { government = fascist_dictatorship }
                NOT = { number_of_states = 4 }
            }
        }
        is_vassal = no
        NOT = { has_country_modifier = neutrality_modifier }
        THIS = {
            NOT = {
                has_country_modifier = neutrality_modifier
                has_country_modifier = disable_conquest_cb
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }

        #AI anti-military will not use this
        OR = {
            THIS = { ai = no }
            THIS = { NOT = { war_policy = anti_military } }
        }

        #AI will not use this when fighting for hegemony
        OR = {
            THIS = { ai = no }
            NOT = {
                AND = {
                    any_owned_province = {
                        any_core = {
                            is_cultural_union = yes
                            this_culture_union = this_union
                        }
                    }
                    any_greater_power = {
                        war_with = THIS
                        culture_has_union_tag = yes
                        is_culture_group = THIS
                        cultural_union = { exists = no }
                    }
                    THIS = { is_greater_power = yes }
                }
            }
        }

        #AI can only grab neighboring states, coastal if it's a coastal GP
        OR = {
            THIS = { ai = no }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = {
                    OR = {
                        is_greater_power = yes
                        is_secondary_power = yes
                    }
                    any_owned_province = { port = yes }
                }
            }
        }

        #AI will not grab cores of allies/spherelings
        OR = {
            THIS = { ai = no }
            NOT = {
                any_owned_province = {
                    any_core = {
                        exists = yes
                        OR = {
                            alliance_with = THIS
                            in_sphere = THIS
                            vassal_of = THIS
                        }
                    }
                }
            }
        }

        #AI will not try to grab cores of their union if they're sphere to a GP of their culture group
        OR = {
            THIS = { ai = no }
            NOT = {
                AND = {
                    THIS = {
                        is_greater_power = no
                        part_of_sphere = yes
                        culture_has_union_tag = yes
                        cultural_union = { exists = no }
                        sphere_owner = { is_culture_group = THIS }
                    }
                    any_owned_province = {
                        any_core = {
                            is_cultural_union = yes
                            this_culture_union = this_union
                        }
                    }
                }
            }
        }

        #pro-military AI will not grab cores of non-existing, non-union countries
        #unless they own some cores or it's part of their culture group
        #jingoistic will also grab existing cores that they already own some of
        #fascist & communist countries are exempt from this
        OR = {
            THIS = { ai = no }
            THIS = { government = proletarian_dictatorship }
            THIS = { government = fascist_dictatorship }
            AND = {
                THIS = { war_policy = pro_military }
                any_owned_province = {
                    any_core = {
                        is_cultural_union = no
                        exists = no
                        OR = {
                            any_core = { owned_by = THIS }
                            is_culture_group = THIS
                        }
                    }
                }
            }
            AND = {
                THIS = { war_policy = jingoism }
                any_owned_province = {
                    any_core = {
                        OR = {
                            any_core = { owned_by = THIS }
                            AND = {
                                exists = no
                                is_cultural_union = no
                                is_culture_group = THIS
                            }
                        }
                    }
                }
            }
        }
    }

    badboy_factor = 2.2
    prestige_factor = 5
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    po_annex = yes

    war_name = WAR_CONQUEST_NAME
}

# Berlin Conference
annex_africa = {
    sprite_index = 21
    is_triggered_only = yes
    months = 12
    crisis = no

    always = yes

    construction_speed = 2.5

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.6
    penalty_factor = 2

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 0

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
        }
        NOT = { is_our_vassal = THIS }
        number_of_states = 2
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        THIS = {
            nationalism_n_imperialism = 1
            capital_scope = { continent = europe }
            NOT = { tag = RUS }
            NOT = { tag = TUR }
            slavery = no_slavery
            OR = {
                is_greater_power = yes
                is_secondary_power = yes
            }
              NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_modifier = claimed_africa }
            NOT = { has_country_flag = congo_award }
            civilized = yes
            has_global_flag = berlin_conference
        }
        NOT = {
            tag = MOR
            tag = ALD
            tag = TRI
            tag = LIB
            tag = CYR
            primary_culture = kefficho
            primary_culture = amhara
            primary_culture = tigray
            primary_culture = oromo
            primary_culture = harari
            has_country_flag = post_colonial_country
        }
        civilized = no
        is_vassal = no
        capital_scope = { continent = africa }
        ai = yes
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = punitive_effects }
            }
        }

        #Claimed colonial regions can't be conquered with this CB
        NOT = {
            #Ghana
            AND = {
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ASH_1909
                                region = FRA_1907
                            }
                        }
                    }
                    any_greater_power  = {
                        any_owned_province = {
                            OR = {
                                region = ASH_1909
                                region = FRA_1907
                            }
                        }
                    }
                }
            }
            #Ivory Coast
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1892
                                region = FRA_1893
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1892
                                region = FRA_1893
                            }
                        }
                    }
                }
            }
            #Nigeria
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1923
                                region = FRA_1927
                                region = FRA_1930
                                region = SOK_1934
                                region = SOK_1945
                                region = SOK_1937
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1923
                                region = FRA_1927
                                region = FRA_1930
                                region = SOK_1934
                                region = SOK_1945
                                region = SOK_1937
                            }
                        }
                    }
                }
            }
            #Guinea
            AND = {
                any_owned_province = { region = FRA_1883 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = FRA_1883 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = FRA_1883 }
                    }
                }
            }
            #Guinea-Bissau
            AND = {
                any_owned_province = { region = FRA_1878 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = FRA_1878 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = FRA_1878 }
                    }
                }
            }
            #Angola
            AND = {
                any_owned_province = { region = POR_1999 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = POR_1999 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = POR_1999 }
                    }
                }
            }
            #Senegal and Mauritania
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1783
                                region = FRA_1788
                                region = FRA_1775
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1783
                                region = FRA_1788
                                region = FRA_1775
                            }
                        }
                    }
                }
            }
            #Mali
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1798
                                region = FRA_1801
                                region = FRA_1803
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1798
                                region = FRA_1801
                                region = FRA_1803
                            }
                        }
                    }
                }
            }
            #Niger
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1808
                                region = FRA_1813
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1808
                                region = FRA_1813
                            }
                        }
                    }
                }
            }
            #Mozambique
            AND = {
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = POR_2049
                                region = POR_2054
                                region = POR_2053
                                region = POR_2060
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = POR_2049
                                region = POR_2054
                                region = POR_2053
                                region = POR_2060
                            }
                        }
                    }
                }
            }
            #South Africa
            AND = {
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ENG_2087
                                region = ENG_2096
                                region = ORA_2103
                                region = TRN_2108
                                region = ZUL_2113
                                region = ENG_2071
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = ENG_2087
                                region = ENG_2096
                                region = ORA_2103
                                region = TRN_2108
                                region = ZUL_2113
                                region = ENG_2071
                            }
                        }
                    }
                }
            }
            #Egypt
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = EGY_1745
                                region = EGY_1758
                                region = EGY_1762
                                region = EGY_1771
                                region = EGY_1755
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = EGY_1745
                                region = EGY_1758
                                region = EGY_1762
                                region = EGY_1771
                                region = EGY_1755
                            }
                        }
                    }
                }
            }
            #Sudan
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = EGY_1834
                                region = EGY_1827
                                region = EGY_1838
                                region = ENG_1844
                                #region = EGY_1842
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = EGY_1834
                                region = EGY_1827
                                region = EGY_1838
                                region = ENG_1844
                                #region = EGY_1842
                            }
                        }
                    }
                }
            }
            #Ethiopia
            AND = {
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ETH_1853
                                region = ETH_1852
                                region = ETH_1865
                                region = ETH_1859
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = ETH_1853
                                region = ETH_1852
                                region = ETH_1865
                                region = ETH_1859
                            }
                        }
                    }
                }
            }
            #Somalia
            AND = {
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = SOM_1868
                                region = SOM_1872
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = SOM_1868
                                region = SOM_1872
                            }
                        }
                    }
                }
            }
        }
    }

    allowed_states = {
        #any_owned_province = { is_colonial = no }
        #NOT = { any_owned_province = { is_capital = yes } }
        OR = {
            THIS = { ai = no }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }

        #Claimed colonial regions can't be conquered with this CB
        NOT = {
            #Ghana
            AND = {
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = ASH_1909
                                    region = FRA_1907
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = ASH_1909
                                    region = FRA_1907
                                }
                            }
                        }
                    }
                }
            }
            #Ivory Coast
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = FRA_1892
                                    region = FRA_1893
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = FRA_1892
                                    region = FRA_1893
                                }
                            }
                        }
                    }
                }
            }
            #Nigeria
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = FRA_1923
                                    region = FRA_1927
                                    region = FRA_1930
                                    region = SOK_1934
                                    region = SOK_1945
                                    region = SOK_1937
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = FRA_1923
                                    region = FRA_1927
                                    region = FRA_1930
                                    region = SOK_1934
                                    region = SOK_1945
                                    region = SOK_1937
                                }
                            }
                        }
                    }
                }
            }
            #Guinea
            AND = {
                any_owned_province = { region = FRA_1883 }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = { region = FRA_1883 }
                        }
                        any_greater_power = {
                            any_owned_province = { region = FRA_1883 }
                        }
                    }
                }
            }
            #Guinea-Bissau
            AND = {
                any_owned_province = { region = FRA_1878 }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = { region = FRA_1878 }
                        }
                        any_greater_power = {
                            any_owned_province = { region = FRA_1878 }
                        }
                    }
                }
            }
            #Angola
            AND = {
                any_owned_province = { region = POR_1999 }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = { region = POR_1999 }
                        }
                        any_greater_power = {
                            any_owned_province = { region = POR_1999 }
                        }
                    }
                }
            }
            #Senegal and Mauritania
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = FRA_1783
                                    region = FRA_1788
                                    region = FRA_1775
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = FRA_1783
                                    region = FRA_1788
                                    region = FRA_1775
                                }
                            }
                        }
                    }
                }
            }
            #Mali
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = FRA_1798
                                    region = FRA_1801
                                    region = FRA_1803
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = FRA_1798
                                    region = FRA_1801
                                    region = FRA_1803
                                }
                            }
                        }
                    }
                }
            }
            #Niger
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = FRA_1808
                                    region = FRA_1813
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = FRA_1808
                                    region = FRA_1813
                                }
                            }
                        }
                    }
                }
            }
            #Mozambique
            AND = {
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = POR_2049
                                    region = POR_2054
                                    region = POR_2053
                                    region = POR_2060
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = POR_2049
                                    region = POR_2054
                                    region = POR_2053
                                    region = POR_2060
                                }
                            }
                        }
                    }
                }
            }
            #South Africa
            AND = {
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = ENG_2087
                                    region = ENG_2096
                                    region = ORA_2103
                                    region = TRN_2108
                                    region = ZUL_2113
                                    region = ENG_2071
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = ENG_2087
                                    region = ENG_2096
                                    region = ORA_2103
                                    region = TRN_2108
                                    region = ZUL_2113
                                    region = ENG_2071
                                }
                            }
                        }
                    }
                }
            }
            #Egypt
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = EGY_1745
                                    region = EGY_1758
                                    region = EGY_1762
                                    region = EGY_1771
                                    region = EGY_1755
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = EGY_1745
                                    region = EGY_1758
                                    region = EGY_1762
                                    region = EGY_1771
                                    region = EGY_1755
                                }
                            }
                        }
                    }
                }
            }
            #Sudan
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = EGY_1834
                                    region = EGY_1827
                                    region = EGY_1838
                                    region = ENG_1844
                                    #region = EGY_1842
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = EGY_1834
                                    region = EGY_1827
                                    region = EGY_1838
                                    region = ENG_1844
                                    #region = EGY_1842
                                }
                            }
                        }
                    }
                }
            }
            #Ethiopia
            AND = {
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = ETH_1853
                                    region = ETH_1852
                                    region = ETH_1865
                                    region = ETH_1859
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = ETH_1853
                                    region = ETH_1852
                                    region = ETH_1865
                                    region = ETH_1859
                                }
                            }
                        }
                    }
                }
            }
            #Somalia
            AND = {
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
                owner = {
                    OR = {
                        any_neighbor_country = {
                            civilized = yes
                            any_owned_province = {
                                OR = {
                                    region = SOM_1868
                                    region = SOM_1872
                                }
                            }
                        }
                        any_greater_power = {
                            any_owned_province = {
                                OR = {
                                    region = SOM_1868
                                    region = SOM_1872
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        add_country_modifier = { name = claimed_africa duration = 120 }
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = { THIS = { add_country_modifier = { name = claimed_africa duration = 120 } } }
}

annex_africa_full = {
    sprite_index = 21
    is_triggered_only = yes
    months = 12
    crisis = no

    always = yes

    construction_speed = 2.5

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.6
    penalty_factor = 2

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 0

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
        }
        NOT = { is_our_vassal = THIS }
        NOT = { number_of_states = 2 }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        THIS = {
            nationalism_n_imperialism = 1
            capital_scope = { continent = europe }
            NOT = { tag = RUS }
            NOT = { tag = TUR }
            slavery = no_slavery
            OR = {
                is_greater_power = yes
                is_secondary_power = yes
            }
              NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_modifier = claimed_africa }
            NOT = { has_country_flag = congo_award }
            civilized = yes
            has_global_flag = berlin_conference
        }
        civilized = no
        is_vassal = no
        NOT = {
            tag = MOR
            tag = ALD
            tag = TRI
            tag = LIB
            tag = CYR
            primary_culture = kefficho
            primary_culture = amhara
            primary_culture = tigray
            primary_culture = oromo
            primary_culture = harari
            has_country_flag = post_colonial_country
        }
        capital_scope = { continent = africa }
        ai = yes
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }

        #Claimed colonial regions can't be conquered with this CB
        NOT = {
            #Ghana
            AND = {
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ASH_1909
                                region = FRA_1907
                            }
                        }
                    }
                    any_greater_power  = {
                        any_owned_province = {
                            OR = {
                                region = ASH_1909
                                region = FRA_1907
                            }
                        }
                    }
                }
            }
            #Ivory Coast
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1892
                                region = FRA_1893
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1892
                                region = FRA_1893
                            }
                        }
                    }
                }
            }
            #Nigeria
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1923
                                region = FRA_1927
                                region = FRA_1930
                                region = SOK_1934
                                region = SOK_1945
                                region = SOK_1937
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1923
                                region = FRA_1927
                                region = FRA_1930
                                region = SOK_1934
                                region = SOK_1945
                                region = SOK_1937
                            }
                        }
                    }
                }
            }
            #Guinea
            AND = {
                any_owned_province = { region = FRA_1883 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = FRA_1883 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = FRA_1883 }
                    }
                }
            }
            #Guinea-Bissau
            AND = {
                any_owned_province = { region = FRA_1878 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = FRA_1878 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = FRA_1878 }
                    }
                }
            }
            #Angola
            AND = {
                any_owned_province = { region = POR_1999 }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = { region = POR_1999 }
                    }
                    any_greater_power = {
                        any_owned_province = { region = POR_1999 }
                    }
                }
            }
            #Senegal and Mauritania
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1783
                                region = FRA_1788
                                region = FRA_1775
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1783
                                region = FRA_1788
                                region = FRA_1775
                            }
                        }
                    }
                }
            }
            #Mali
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1798
                                region = FRA_1801
                                region = FRA_1803
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1798
                                region = FRA_1801
                                region = FRA_1803
                            }
                        }
                    }
                }
            }
            #Niger
            AND = {
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = FRA_1808
                                region = FRA_1813
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = FRA_1808
                                region = FRA_1813
                            }
                        }
                    }
                }
            }
            #Mozambique
            AND = {
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = POR_2049
                                region = POR_2054
                                region = POR_2053
                                region = POR_2060
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = POR_2049
                                region = POR_2054
                                region = POR_2053
                                region = POR_2060
                            }
                        }
                    }
                }
            }
            #South Africa
            AND = {
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ENG_2087
                                region = ENG_2096
                                region = ORA_2103
                                region = TRN_2108
                                region = ZUL_2113
                                region = ENG_2071
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = ENG_2087
                                region = ENG_2096
                                region = ORA_2103
                                region = TRN_2108
                                region = ZUL_2113
                                region = ENG_2071
                            }
                        }
                    }
                }
            }
            #Egypt
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = EGY_1745
                                region = EGY_1758
                                region = EGY_1762
                                region = EGY_1771
                                region = EGY_1755
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = EGY_1745
                                region = EGY_1758
                                region = EGY_1762
                                region = EGY_1771
                                region = EGY_1755
                            }
                        }
                    }
                }
            }
            #Sudan
            AND = {
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = EGY_1834
                                region = EGY_1827
                                region = EGY_1838
                                region = ENG_1844
                                #region = EGY_1842
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = EGY_1834
                                region = EGY_1827
                                region = EGY_1838
                                region = ENG_1844
                                #region = EGY_1842
                            }
                        }
                    }
                }
            }
            #Ethiopia
            AND = {
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = ETH_1853
                                region = ETH_1852
                                region = ETH_1865
                                region = ETH_1859
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = ETH_1853
                                region = ETH_1852
                                region = ETH_1865
                                region = ETH_1859
                            }
                        }
                    }
                }
            }
            #Somalia
            AND = {
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
                OR = {
                    any_neighbor_country = {
                        civilized = yes
                        any_owned_province = {
                            OR = {
                                region = SOM_1868
                                region = SOM_1872
                            }
                        }
                    }
                    any_greater_power = {
                        any_owned_province = {
                            OR = {
                                region = SOM_1868
                                region = SOM_1872
                            }
                        }
                    }
                }
            }
        }
    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        add_country_modifier = { name = claimed_africa duration = 120 }
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = {
        THIS = { add_country_modifier = { name = claimed_africa duration = 120 } }
        tech_school = developing_tech_school
    }
}

# Establish Protectorate
establish_protectorate_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 0.5

    badboy_factor = 1.5
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        civilized = no
        is_vassal = no
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        NOT = { is_our_vassal = THIS }
        NOT = {
            has_country_modifier = neutrality_modifier
            number_of_states = 2
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
        OR = {
            THIS = { war_policy = jingoism }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }

        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        THIS = {
            civilized = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            THIS = { NOT = { nationalism_n_imperialism = 1 } }
            NOT = { has_global_flag = berlin_conference }
            civilization_progress = 0.6
            has_country_flag = post_colonial_country
        }
        OR = {
            THIS = { NOT = { nationalism_n_imperialism = 1 } }
            civilization_progress = 0.6
            has_country_flag = post_colonial_country
            AND = {
                THIS = { nationalism_n_imperialism = 1 }
                capital_scope = { continent = africa }
            }
        }

        #Restrictions to non-African State conquering
        OR = {
            capital_scope = { continent = africa }

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
				OR = {
					THIS = { machine_guns = 1 }
					THIS = { total_pops = 3000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
				OR = {
					THIS = {
						bolt_action_rifles = 1
						army_risk_management = 1
					}
					THIS = { total_pops = 5000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
				OR = {
					THIS = {
						modern_divisional_structure = 1
						army_nco_training = 1
					}
					THIS = { total_pops = 6000000 }
				}
            }
        } ###End of Non-African Restrictions

    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
    on_po_accepted = { tech_school = developing_tech_school }
}

establish_protectorate_NI_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 0.8

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 0.8
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        NOT = { is_our_vassal = THIS }
        THIS = {
            civilized = yes
            nationalism_n_imperialism = 1
            NOT = {
                has_country_modifier = neutrality_modifier
                has_global_flag = berlin_conference
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            NOT = {
                civilization_progress = 0.6
                has_country_flag = post_colonial_country
            }
            AND = {
                tag = KOR
                THIS = { tag = JAP }
            }
        }
        NOT = {
            has_country_modifier = neutrality_modifier
            capital_scope = { continent = africa }
            number_of_states = 7
        }
        civilized = no
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }

        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }

        #Restrictions to non-African State conquering
        OR = {
            capital_scope = { continent = africa }

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
                OR = {
					THIS = { machine_guns = 1 }
					THIS = { total_pops = 3000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
               OR = {
					THIS = {
						bolt_action_rifles = 1
						army_risk_management = 1
					}
					THIS = { total_pops = 5000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
                OR = {
					THIS = {
						modern_divisional_structure = 1
						army_nco_training = 1
					}
					THIS = { total_pops = 6000000 }
				}
            }
        } ###End of Non-African Restrictions
    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
    on_po_accepted = { tech_school = developing_tech_school }
}

establish_protectorate_BC_casus_belli = {
    sprite_index = 7
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 1

    badboy_factor = 0.5
    prestige_factor = 1
    peace_cost_factor = 0.6
    penalty_factor = 1

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { any_owned_province = { port = yes } }
            }
        }
        NOT = { is_our_vassal = THIS }
        THIS = {
            civilized = yes
            nationalism_n_imperialism = 1
            has_global_flag = berlin_conference
            NOT = { has_country_modifier = neutrality_modifier }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            NOT = {
                civilization_progress = 0.6
                has_country_flag = post_colonial_country
            }
            AND = {
                tag = KOR
                THIS = { tag = JAP }
            }
        }
        NOT = {
            civilized = yes
            war_with = THIS
            has_country_modifier = neutrality_modifier
        }
        OR = {
            NOT = { number_of_states = 12 }
            capital_scope = { continent = africa }
        }
        civilized = no
        is_vassal = no
        #OR = {
        #    war_with = THIS
        #    THIS = { NOT = { has_country_modifier = punitive_effects } }
        #}

        OR = {
            THIS = { ai = no }
            THIS = { war_policy = jingoism NOT = { government = democracy } }
            NOT = {
                THIS = {
                    OR = {
                        capital_scope = { continent = south_america }
                        capital_scope = { continent = north_america }
                        capital_scope = { continent = australia_new_zealand }
                    }
                }
            }
        }

        #Restrictions to non-African State conquering
        OR = {
            capital_scope = { continent = africa }

            NOT = { total_pops = 500000 }

            AND = {
                NOT = { total_pops = 1000000 }
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_logistics = 1
                    }
                    THIS = {
                        ai = yes
                        raider_group_doctrine = 1
                        iron_steamers = 1
                    }
                }
            }

            AND = {
                NOT = { total_pops = 2000000 }
                OR = {
					THIS = { machine_guns = 1 }
					THIS = { total_pops = 3000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_directionism = 1
                    }
                    THIS = {
                        ai = yes
                        steam_turbine_ships = 1
                    }
                }
            }
            AND = {
                NOT = { total_pops = 3000000 }
                OR = {
					THIS = {
						bolt_action_rifles = 1
						army_risk_management = 1
					}
					THIS = { total_pops = 5000000 }
				}
                OR = {
                    capital_scope = { is_overseas = no }
                    THIS = {
                        ai = no
                        naval_integration = 1
                    }
                    THIS = {
                        ai = yes
                        oil_driven_ships = 1
                    }
                }
            }
            AND = {
                total_pops = 3000000
                OR = {
					THIS = {
						modern_divisional_structure = 1
						army_nco_training = 1
					}
					THIS = { total_pops = 6000000 }
				}
            }
        } ###End of Non-African Restrictions
    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
    on_po_accepted = { tech_school = developing_tech_school }
}

#Status Quo
status_quo = {
    sprite_index = 1
    is_triggered_only = yes
    months = 12
    constructing_cb = no

    can_use = {
        NOT = { is_our_vassal = THIS }
        always = no
    }

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    po_status_quo = yes

    war_name = WAR_NAME
}

#New with AHD
cut_down_to_size_boxer = {
    sprite_index = 8
    is_triggered_only = yes
    months = 12
    constructing_cb = no
    crisis = no

    can_use = {
        tag = QNG
        civilized = no
        has_country_flag = boxers_appeared
        NOT = { has_country_flag = boxers_disbanded }
    }

    badboy_factor = 1.1
    prestige_factor = 5
    peace_cost_factor = 12.5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    po_disarmament = yes
    po_reparations = yes

    war_name = WAR_BOXER_NAME

    on_add = {
        set_country_flag = intervened_boxer_war
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        THIS = { clr_country_flag = intervened_boxer_war }
        country_event = 99015
    }
}

# Make Puppet
make_puppet = {
    sprite_index = 18
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 2.0
    prestige_factor = 1
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                }
            }
        }
        NOT = {
            is_our_vassal = THIS
            has_country_modifier = neutrality_modifier
            total_pops = 5000000
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
            any_neighbor_country = {
                OR = {
                    vassal_of = THIS
                    substate_of = THIS
                    in_sphere = THIS
                }
            }
        }
        is_vassal = no
        is_greater_power = no
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope

    po_make_puppet = yes

    war_name = WAR_PUPPET_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        country_event = 19370
    }
}

# Become Independent
become_independent = {
    sprite_index = 10
    is_triggered_only = yes
    months = 12
    crisis = no

    always = yes

    badboy_factor = 1
    prestige_factor = 1
    peace_cost_factor = 5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 108

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        is_our_vassal = THIS
        THIS = { is_substate = no }
        NOT = { has_country_modifier = neutrality_modifier }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        OR = {
            FROM = { is_our_vassal = THIS }
            war_with = THIS
        }
    }

    po_release_puppet = yes
    po_add_to_sphere = yes

    war_name = WAR_INDEPENDENCE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
        add_war_goal = {
            casus_belli = make_puppet
        }
        leave_alliance = FROM
        release_vassal = THIS
    }
}

# Revert from Communist Government
uninstall_communist_gov_cb = {
    sprite_index = 13
    is_triggered_only = yes
    months = 12
    crisis = no

    # Is automatically added to countries that intervened at while install_communist_gov_cb
    # so they can revert those countries government.
    constructing_cb = no

    badboy_factor = 0.5
    prestige_factor = 1
    peace_cost_factor = 5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        THIS = { NOT = { ruling_party_ideology = communist } }
        government = proletarian_dictatorship
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = {
                    has_country_modifier = no_more_war
                }
            }
        }
    }

    po_uninstall_communist_gov_type = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

great_war_install_democracy = {
    sprite_index = 19
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 30
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1
    always = yes

    can_use = {
        THIS = {
            has_country_flag = in_great_war
            is_greater_power = yes
            OR = {
                government = hms_government
                government = democracy
            }
        }
        has_country_flag = in_great_war
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        war_with = THIS
        OR = {
            government = proletarian_dictatorship
            government = fascist_dictatorship
        }
    }

    po_remove_prestige = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = { set_country_flag = friendly_democracy }
        country_event = 96085
    }
}

great_war_install_fascism = {
    sprite_index = 17
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 30
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1
    always = yes

    can_use = {
        THIS = {
            has_country_flag = in_great_war
            is_greater_power = yes
            government = fascist_dictatorship
        }
        has_country_flag = in_great_war
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        war_with = THIS
        NOT = { government = fascist_dictatorship }
    }

    po_remove_prestige = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = { set_country_flag = friendly_fascist }
        country_event = 96086
    }
}

great_war_install_communism = {
    sprite_index = 12
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 0
    prestige_factor = 1
    peace_cost_factor = 30
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1
    always = yes

    can_use = {
        THIS = {
            has_country_flag = in_great_war
            is_greater_power = yes
            government = proletarian_dictatorship
        }
        has_country_flag = in_great_war
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        war_with = THIS
        NOT = { government = proletarian_dictatorship }
    }

    po_remove_prestige = yes
    po_install_communist_gov_type = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = { set_country_flag = friendly_communist }
        country_event = 96087
    }
}

install_democracy = {
    sprite_index = 19
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 1.5
    prestige_factor = 1
    peace_cost_factor = 50
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        THIS = {
            NOT = { has_country_flag = in_great_war }
            is_greater_power = yes
            OR = {
                government = hms_government
                government = democracy
            }
        }
        has_global_flag = great_wars_enabled
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        OR = {
            government = proletarian_dictatorship
            government = fascist_dictatorship
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = {
                    has_country_flag = in_great_war
                    has_country_modifier = no_more_war
                }
            }
        }
    }

    po_remove_prestige = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = {
            set_country_flag = friendly_democracy
            any_country = {
                limit = {
                    OR = {
                        government = proletarian_dictatorship
                        government = fascist_dictatorship
                    }
                }
                relation = { who = THIS value = -50 }
            }
        }
        country_event = 96085
    }
}

install_fascism = {
    sprite_index = 17
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 2
    prestige_factor = 1
    peace_cost_factor = 50
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        THIS = {
            NOT = { has_country_flag = in_great_war }
            government = fascist_dictatorship
        }
        is_ideology_enabled = fascist
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        NOT = { government = fascist_dictatorship }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = {
                    has_country_flag = in_great_war
                    has_country_modifier = no_more_war
                }
            }
        }
    }

    po_remove_prestige = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = {
            set_country_flag = friendly_fascist
            any_country = {
                limit = {
                    OR = {
                        government = hms_government
                        government = democracy
                    }
                }
                relation = { who = THIS value = -50 }
            }
        }
        country_event = 96086
    }
}

install_communism = {
    sprite_index = 12
    is_triggered_only = yes
    months = 12
    construction_speed = 1.5
    crisis = no

    badboy_factor = 2
    prestige_factor = 1
    peace_cost_factor = 50
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        THIS = {
            NOT = { has_country_flag = in_great_war }
            government = proletarian_dictatorship
        }
        is_ideology_enabled = communist
        is_vassal = no
        civilized = yes
        NOT = { is_our_vassal = THIS }
        NOT = { government = proletarian_dictatorship }
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        OR = {
            war_with = THIS
            THIS = {
                NOT = {
                    has_country_flag = in_great_war
                    has_country_modifier = no_more_war
                }
            }
        }
    }

    po_remove_prestige = yes
    po_install_communist_gov_type = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = {
        THIS = {
            set_country_flag = friendly_communist
            any_country = {
                limit = {
                    OR = {
                        government = hms_government
                        government = democracy
                    }
                }
                relation = { who = THIS value = -50 }
            }
        }
        country_event = 96087
    }
}

# Gain control of Substate region
acquire_substate_region = {
    sprite_index = 6
    is_triggered_only = yes
    months = 12
    crisis = no

    construction_speed = 0.5

    badboy_factor = 2.2
    prestige_factor = 2
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        num_of_substates = 1 # if has any substate
        THIS = { ai = no }
        any_substate = {
            OR = {
                neighbour = THIS
                AND = {
                    THIS = { total_amount_of_ships = 5 }
                    any_owned_province = { port = yes }
                }
            }
            number_of_states = 1
            any_owned_province = {
                not = { is_core = THIS }
                is_colonial = no
            }
        }
    }

    allowed_substate_regions = {
        is_colonial = no
        #owner = { NOT = { in_sphere = THIS } }
        any_owned_province = {
            not = {    is_core = THIS }
            is_colonial = no
        }
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
        }
    }

    po_demand_state = yes

    war_name = WAR_TAKE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Colonial competition
colonial_competition = {
    sprite_index = 31
    is_triggered_only = yes
    constructing_cb = no    # only used in crises
    crisis = no
    months = 12

    badboy_factor = 0
    prestige_factor = 2
    peace_cost_factor = 0.9
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    po_colony = yes

    war_name = WAR_COLONIAL_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }
}

# Dismantle fortifications (forts + naval bases)
dismantle_forts = {
    sprite_index = 16
    is_triggered_only = yes
    months = 12

    badboy_factor = 1
    prestige_factor = 0.5
    peace_cost_factor = 5
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1


    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = {
            is_our_vassal = THIS
            has_country_modifier = neutrality_modifier
        }
        is_vassal = no
        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = neutrality_modifier }
                military_score = 1
            }
        }
        THIS = { civilized = yes }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            THIS = { government = fascist_dictatorship }
            THIS = { government = proletarian_dictatorship }
            THIS = { civilized = no }
            war_with = THIS
            NOT = { relation = { who = THIS value = 0 } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal's state
    allowed_states = {
        any_owned_province = {
            OR = {
                has_building = fort
                has_building = naval_base
            }
        }
        OR = {
            THIS = { ai = no }
            any_owned_province = { any_neighbor_province = { owned_by = THIS } }
            AND = {
                any_owned_province = { port = yes }
                THIS = { is_greater_power = yes }
            }
        }
    }

    po_destroy_forts = yes
    po_destroy_naval_bases = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
    }
}

#Placeholder for calling allies
call_allies_cb = {
    sprite_index = 11
    is_triggered_only = yes
    months = 1
    constructing_cb = no
    crisis = no

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 1
    penalty_factor = 0

    break_truce_prestige_factor = 0
    break_truce_infamy_factor = 0
    break_truce_militancy_factor = 0
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        THIS = { ai = yes }
        always = no
    }

    po_remove_prestige = yes

    war_name = WAR_NAME

    on_add = {
    }
}

#Placeholder for acquire state-by-event
acquire_any_state = {
    sprite_index = 6
    is_triggered_only = yes
    months = 12
    constructing_cb = no
    crisis = no

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 0
    break_truce_infamy_factor = 0
    break_truce_militancy_factor = 0
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        is_vassal = no
        NOT = { is_our_vassal = THIS }
        always = no
    }

    allowed_states = {
    }

    po_demand_state = yes

    war_name = WAR_TAKE_NAME

    on_add = {
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                owner = {
                    civilized = no
                    is_culture_group = east_asian
                    OR = {
                        owns = 1481
                        owns = 1496
                        owns = 1498
                        owns = 1538
                        owns = 1566
                        owns = 1569
                        owns = 1606
                        owns = 2632
                    }
                }
                THIS = {
                    civilized = yes
                    NOT = { is_culture_group = east_asian }
                    any_owned_province = { port = yes }
                }
            }
            owner = { country_event = 1316089 }
        }
    }
}

conquest_any = {
    sprite_index = 22
    is_triggered_only = yes
    months = 12
    constructing_cb = no
    crisis = no

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
        always = no
    }

    badboy_factor = 0
    prestige_factor = 0
    peace_cost_factor = 1
    penalty_factor = 1

    break_truce_prestige_factor = 0
    break_truce_infamy_factor = 0
    break_truce_militancy_factor = 0
    truce_months = 48

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    po_annex = yes

    war_name = WAR_CONQUEST_ANY_NAME

    on_add = {
    }

    on_po_accepted = {
        THIS = {
            random_owned = {
                limit = { is_core = TRN TRN = { exists = no has_country_flag = uncivilize_on_conquest } }
                THIS = { release_vassal = TRN }
                TRN = { clr_country_flag = uncivilize_on_conquest civilized = no annex_to = THIS }
                TRN = { civilized = yes }
            }
            random_owned = {
                limit = { is_core = ORA ORA = { exists = no has_country_flag = uncivilize_on_conquest } }
                THIS = { release_vassal = ORA }
                ORA = { clr_country_flag = uncivilize_on_conquest civilized = no annex_to = THIS }
                ORA = { civilized = yes }
            }
            random_owned = {
                limit = { is_core = NAL NAL = { exists = no has_country_flag = uncivilize_on_conquest } }
                THIS = { release_vassal = NAL }
                NAL = { clr_country_flag = uncivilize_on_conquest civilized = no annex_to = THIS }
                NAL = { civilized = yes }
            }
        }
    }
}

#Treaty Port
treaty_port_casus_belli = {
    sprite_index = 32
    is_triggered_only = yes
    months = 12
    crisis = no

    badboy_factor = 1
    prestige_factor = 0.5
    peace_cost_factor = 10
    penalty_factor = 2

    break_truce_prestige_factor = 4
    break_truce_infamy_factor = 4
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 0

    always = no

    can_use = {
        NOT = { is_our_vassal = THIS }
        THIS = {
            civilized = yes
            is_disarmed = no
            any_owned_province = { has_building = naval_base }
            NOT = { has_country_modifier = neutrality_modifier }
            OR = {
                naval_plans = 1
                ai = yes
            }
            OR = {
                AND = {
                    military_score = 25
                    total_amount_of_ships = 25
                    total_pops = 250000
                    rank = 16
                }
                war_with = THIS
            }
            OR = {
                NOT = { war_policy = pacifism }
                ai = no
                war_with = THIS
            }
        }
        NOT = { has_country_modifier = neutrality_modifier }
        civilized = no
        is_vassal = no
        num_of_cities = 2
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }

        OR = {
            owns = 1498 #Macao
            owns = 1538 #Shanghai
            owns = 1496 #Hong Kong
            owns = 1566    #Qingdao
            owns = 1481 #Lushun - Port Arthur
            owns = 1569 #Weihai
            owns = 1606 #Jiaxing
            owns = 2681 #Taibei
            owns = 2562 #Tainan
            owns = 1499 #Hainan
            owns = 2632 #Kwangchowan
            owns = 1608 #Ningbo
            owns = 1071 #Qeshm
            owns = 1695 #Ifni
            owns = 2640 #Gwadar
            owns = 1177 #Socotra
            owns = 2048 #Zanzibar
            owns = 1637 #Cheju
            owns = 2589 #Tsushima
            owns = 12 #Sado
        }
    }

    po_reparations = yes

    tws_battle_factor = 1.5

    war_name = PUNITIVE_EXPEDITION_WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                owner = {
                    civilized = no
                    OR = {
                        owns = 1498 #Macao
                        owns = 1538 #Shanghai
                        owns = 1496 #Hong Kong
                        owns = 1566    #Qingdao
                        owns = 1481 #Lushun - Port Arthur
                        owns = 1569 #Weihaiwei
                        owns = 1606 #Jiaxing
                        owns = 2681 #Taibei
                        owns = 2562 #Tainan
                        owns = 1499 #Hainan
                        owns = 2632 #Kwangchowan
                        owns = 1608 #Ningbo
                        owns = 1071 #Qeshm
                        owns = 1695 #Ifni
                        owns = 2640 #Gwadar
                        owns = 1177 #Socotra
                        owns = 2048 #Zanzibar
                        owns = 1637 #Cheju
                        owns = 2589 #Tsushima
                        owns = 12 #Sado
                    }
                }
                THIS = {
                    civilized = yes
                    NOT = { is_culture_group = east_asian }
                    any_owned_province = { port = yes }
                }
            }
            owner = { add_country_modifier = { name = negotiating_unequal_treaty duration = 30 } }
            THIS = { add_country_modifier = { name = negotiating_treaty duration = 30 } }
        }
        #random_owned = { limit = { owner = { civilized = no has_country_modifier = uncivilized_isolationism } }
        #    owner = { remove_country_modifier = uncivilized_isolationism }
        #}
        #random_owned = { limit = { owner = { civilized = no NOT = { has_country_modifier = western_influences } } }
        #    owner = { add_country_modifier = { name = western_influences duration = -1 } }
        #}
        #random_owned = { limit = { owner = { civilized = no NOT = { capital_scope = { has_country_modifier = legation_quarter } } } }
        #    owner = { capital_scope = { add_province_modifier = { name = legation_quarter duration = -1 } } }
        #}
    }
}

install_fascism_make_puppet = {
    sprite_index = 17
    is_triggered_only = yes
    constructing_cb = no
    months = 12
    crisis = no

    badboy_factor = 2
    prestige_factor = 1
    peace_cost_factor = 1.17
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
    }

    po_make_puppet = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = { THIS = { set_country_flag = friendly_fascist_puppet } country_event = 96086 }
}

install_communism_make_puppet = {
    sprite_index = 12
    is_triggered_only = yes
    constructing_cb = no
    months = 12
    crisis = no

    badboy_factor = 2
    prestige_factor = 1
    peace_cost_factor = 1.17
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
    }

    po_make_puppet = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = { THIS = { set_country_flag = friendly_communist_puppet } country_event = 96087 }
}

install_democracy_make_puppet = {
    sprite_index = 19
    is_triggered_only = yes
    constructing_cb = no
    months = 12
    crisis = no

    badboy_factor = 2
    prestige_factor = 1
    peace_cost_factor = 1.17
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        NOT = { is_our_vassal = THIS }
        is_vassal = no
    }

    po_make_puppet = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.05
        }
    }

    on_po_accepted = { THIS = { set_country_flag = friendly_democracy_puppet } country_event = 96085 }
}

#Colonial Conquest/Imperialism CB
colonial_conquest = {
    sprite_index = 21
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 0.25
    peace_cost_factor = 0.6
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
            war_with = THIS
        }
        number_of_states = 2
        NOT = { has_country_modifier = neutrality_modifier }
        is_vassal = no
        civilized = no
        exists = yes
        OR = {
            NOT = { relation = { who = THIS value = 150 } }
            THIS = { ai = no }
            war_with = THIS
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { badboy = 0.88 } }
        }
        THIS = {
            civilized = yes
            NOT = { has_country_modifier = no_more_war }
            NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_modifier = punitive_effects }
            NOT = { has_country_modifier = claimed_africa }
            is_disarmed = no
            NOT = { war_policy = pacifism }
            OR = {
                AND = {
                    capital_scope = { continent = europe }
                    NOT = {
                        tag = TUR
                        tag = RUS
                    }
                }
                tech_school = naval_tech_school
                tech_school = japanese_tech_school
            }
            state_n_government = 1
        }

        OR = {
            #Mozambique
            AND = {
                THIS = {
                    capital_scope = { continent = europe }
                    OR = {
                        NOT = { has_global_flag = berlin_conference }
                        NOT = { nationalism_n_imperialism = 1 }
                    }
                    OR = {
                        has_country_flag = reconquest_of_lourenco_marques
                        AND = {
                            owns = 2060
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2060
                        region = POR_2053
                        region = POR_2054
                        region = POR_2049
                    }
                }
            }
            #Algiers
            AND = {
                THIS = {
                    capital_scope = { continent = europe }
                    OR = {
                        has_country_flag = marched_through_the_iron_gates
                        AND = {
                            owns = 1700
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Yemen
            AND = {
                THIS = {
                    nationalism_n_imperialism = 1
                    OR = {
                        owns = 1412
                        is_sphere_leader_of = LHJ
                    }
                }
                any_owned_province = { region = YEM_1412 }
            }
            #Indonesia
            AND = {
                THIS = { owns = 1413 }
                any_owned_province = {
                    OR = {
                        region = ATJ_1405
                        region = NET_1401
                        region = NET_1398
                        region = NET_1413
                        region = NET_1426
                        region = NET_1423
                        region = NET_1418
                        region = NET_1449
                        region = BAL_1438
                        region = NET_1451
                        region = NET_1446
                    }
                }
            }
            #Laos
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = LUA_1356 }
            }
            #Cambodia
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = SIA_1366 }
            }
            #Burma
            AND = {
                THIS = {
                    OR = {
                        AND = {
                            owns = 1251
                            owns = 1236
                            any_owned_province = { is_core = BUR }
                            has_global_flag = berlin_conference
                        }
                        AND = {
                            has_country_flag = empress_of_india
                            revolution_n_counterrevolution = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = BUR_1330
                        region = BUR_1334
                        region = BUR_1339
                        #region = SIA_1355
                        region = ENG_1343
                    }
                }
            }
            #Vietnam
            AND = {
                THIS = {
                    has_global_flag = berlin_conference
                    OR = {
                        AND = {
                            owns = 1380
                            owns = 1369
                            revolution_n_counterrevolution = 1
                        }
                        has_country_flag = created_my_indochina
                    }
                }
                any_owned_province = {
                    OR = {
                        region = DAI_1380
                        region = DAI_1375
                        region = DAI_1369
                    }
                }
            }
            #Malaysia
            AND = {
                THIS = {
                    owns = 1384
                    OR = {
                        revolution_n_counterrevolution = 1
                        AND = {
                            has_global_flag = berlin_conference
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_1391
                        region = ENG_1384
                    }
                }
            }
        }

        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    allowed_states = {
        OR = {
            #Mozambique
            AND = {
                THIS = {
                    capital_scope = { continent = europe }
                    OR = {
                        NOT = { has_global_flag = berlin_conference }
                        NOT = { nationalism_n_imperialism = 1 }
                    }
                    OR = {
                        has_country_flag = reconquest_of_lourenco_marques
                        AND = {
                            owns = 2060
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2060
                        region = POR_2053
                        region = POR_2054
                        region = POR_2049
                    }
                }
            }
            #Algiers
            AND = {
                THIS = {
                    capital_scope = { continent = europe }
                    OR = {
                        has_country_flag = marched_through_the_iron_gates
                        AND = {
                            owns = 1700
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Yemen
            AND = {
                THIS = {
                    capital_scope = { continent = europe }
                    nationalism_n_imperialism = 1
                    OR = {
                        owns = 1412
                        is_sphere_leader_of = LHJ
                    }
                }
                any_owned_province = { region = YEM_1412 }
            }
            #Indonesia
            AND = {
                THIS = { owns = 1413 }
                any_owned_province = {
                    OR = {
                        region = ATJ_1405
                        region = NET_1401
                        region = NET_1398
                        region = NET_1413
                        region = NET_1426
                        region = NET_1423
                        region = NET_1418
                        region = NET_1449
                        region = BAL_1438
                        region = NET_1451
                        region = NET_1446
                    }
                }
            }
            #Laos
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = LUA_1356 }
            }
            #Cambodia
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = SIA_1366 }
            }
            #Burma
            AND = {
                THIS = {
                    OR = {
                        AND = {
                            owns = 1251
                            owns = 1236
                            any_owned_province = { is_core = BUR }
                            has_global_flag = berlin_conference
                        }
                        AND = {
                            has_country_flag = empress_of_india
                            revolution_n_counterrevolution = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = BUR_1330
                        region = BUR_1334
                        region = BUR_1339
                        #region = SIA_1355
                        region = ENG_1343
                    }
                }
            }
            #Vietnam
            AND = {
                THIS = {
                    has_global_flag = berlin_conference
                    OR = {
                        AND = {
                            owns = 1380
                            owns = 1369
                            revolution_n_counterrevolution = 1
                        }
                        has_country_flag = created_my_indochina
                    }
                }
                any_owned_province = {
                    OR = {
                        region = DAI_1380
                        region = DAI_1375
                        region = DAI_1369
                    }
                }
            }
            #Malaysia
            AND = {
                THIS = {
                    owns = 1384
                    OR = {
                        revolution_n_counterrevolution = 1
                        AND = {
                            has_global_flag = berlin_conference
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_1391
                        region = ENG_1384
                    }
                }
            }

        }
    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        random_list = {
            25 = { badboy = 0.5 }
            25 = { badboy = 1 }
            25 = { badboy = 1.5 }
            25 = { badboy = 2 }
        }

        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        THIS = {
            random_list = {
                20 = { add_country_modifier = { name = claimed_africa duration = 365 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 730 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1095 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1460 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1825 } }
            }
        }

        THIS = {
            random_owned = {
                limit = { owner = { has_global_flag = mozambique_created } }
                owner = {
                    any_owned = {
                        limit = {
                            NOT = { is_core = MOZ }
                            OR = {
                                region = POR_2060
                                region = POR_2053
                                region = POR_2054
                                region = POR_2049
                            }
                        }
                        add_core = MOZ
                        remove_core = GAZ
                        remove_core = AGC
                        remove_core = ZUL
                        remove_core = SHO
                    }
                }
            }
        }
    }
}

#Colonial Conquest/Imperialism Annex
colonial_conquest_full = {
    sprite_index = 21
    months = 12

    construction_speed = 0.8

    badboy_factor = 0
    prestige_factor = 0.25
    peace_cost_factor = 1
    penalty_factor = 1
    always = yes

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            AND = {
                THIS = { total_amount_of_ships = 5 }
                any_owned_province = { port = yes }
            }
            neighbour = THIS
        }
        NOT = { number_of_states = 2 }
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_modifier = neutrality_modifier }
        is_vassal = no
        civilized = no
        exists = yes
        OR = {
            NOT = { relation = { who = THIS value = 150 } }
            THIS = { ai = no }
            war_with = THIS
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { badboy = 0.88 } }
        }
        THIS = {
            civilized = yes
            NOT = { has_country_modifier = no_more_war }
            NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_modifier = punitive_effects }
            NOT = { has_country_modifier = claimed_africa }
            is_disarmed = no
            NOT = { war_policy = pacifism }
            capital_scope = { continent = europe }
            state_n_government = 1
        }

        OR = {
            #Mozambique
            AND = {
                THIS = {
                    OR = {
                        NOT = { has_global_flag = berlin_conference }
                        NOT = { nationalism_n_imperialism = 1 }
                    }
                    OR = {
                        has_country_flag = reconquest_of_lourenco_marques
                        AND = {
                            owns = 2060
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2060
                        region = POR_2053
                        region = POR_2054
                        region = POR_2049
                    }
                }
            }
            #Algiers
            AND = {
                THIS = {
                    OR = {
                        has_country_flag = marched_through_the_iron_gates
                        AND = {
                            owns = 1700
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Yemen
            AND = {
                THIS = {
                    nationalism_n_imperialism = 1
                    OR = {
                        owns = 1412
                        is_sphere_leader_of = LHJ
                    }
                }
                any_owned_province = { region = YEM_1412 }
            }
            #Indonesia
            AND = {
                THIS = { owns = 1413 }
                any_owned_province = {
                    OR = {
                        region = ATJ_1405
                        region = NET_1401
                        region = NET_1398
                        region = NET_1413
                        region = NET_1426
                        region = NET_1423
                        region = NET_1418
                        region = NET_1449
                        region = BAL_1438
                        region = NET_1451
                        region = NET_1446
                    }
                }
            }

            #Indonesia
            AND = {
                THIS = { owns = 1413 }
                any_owned_province = {
                    OR = {
                        region = ATJ_1405
                        region = NET_1401
                        region = NET_1398
                        region = NET_1413
                        region = NET_1426
                        region = NET_1423
                        region = NET_1418
                        region = NET_1449
                        region = BAL_1438
                        region = NET_1451
                        region = NET_1446
                    }
                }
            }

            #Laos
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = LUA_1356 }
            }

            #Cambodia
            AND = {
                THIS = {
                    revolution_n_counterrevolution = 1
                    has_global_flag = berlin_conference
                    has_country_flag = created_my_indochina
                }
                any_owned_province = { region = SIA_1366 }
            }

            #Burma
            AND = {
                THIS = {
                    OR = {
                        AND = {
                            owns = 1251
                            owns = 1236
                            any_owned_province = { is_core = BUR }
                            has_global_flag = berlin_conference
                        }
                        AND = {
                            has_country_flag = empress_of_india
                            revolution_n_counterrevolution = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = BUR_1330
                        region = BUR_1334
                        region = BUR_1339
                        #region = SIA_1355
                        region = ENG_1343
                    }
                }
            }

            #Vietnam
            AND = {
                THIS = {
                    has_global_flag = berlin_conference
                    OR = {
                        AND = {
                            owns = 1380
                            owns = 1369
                            revolution_n_counterrevolution = 1
                        }
                        has_country_flag = created_my_indochina
                    }
                }
                any_owned_province = {
                    OR = {
                        region = DAI_1380
                        region = DAI_1375
                        region = DAI_1369
                    }
                }
            }

            #Malaysia
            AND = {
                THIS = {
                    owns = 1384
                    OR = {
                        revolution_n_counterrevolution = 1
                        AND = {
                            has_global_flag = berlin_conference
                            nationalism_n_imperialism = 1
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_1391
                        region = ENG_1384
                    }
                }
            }
        }

        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = punitive_effects } }
        }
    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        random_list = {
            25 = { badboy = 0.5 }
            25 = { badboy = 1 }
            25 = { badboy = 1.5 }
            25 = { badboy = 2 }
        }

        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        THIS = {
            random_list = {
                20 = { add_country_modifier = { name = claimed_africa duration = 365 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 730 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1095 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1460 } }
                20 = { add_country_modifier = { name = claimed_africa duration = 1825 } }
            }
        }

        THIS = {
            random_owned = {
                limit = { owner = { has_global_flag = mozambique_created } }
                owner = {
                    any_owned = {
                        limit = {
                            NOT = { is_core = MOZ }
                            OR = {
                                region = POR_2060
                                region = POR_2053
                                region = POR_2054
                                region = POR_2049
                            }
                        }
                        add_core = MOZ
                        remove_core = GAZ
                        remove_core = AGC
                        remove_core = ZUL
                        remove_core = SHO
                    }
                }
            }
        }
    }
}

# War Reparations
war_reparations = {
    sprite_index = 27
    is_triggered_only = yes
    months = 12
    construction_speed = 0.8

    badboy_factor = 0.25
    prestige_factor = 0.5
    peace_cost_factor = 20
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        OR = {
            war_with = THIS
            AND = {
                has_country_modifier = nationalization_in_progress
                THIS = { has_country_modifier = factories_nationalized }
            }
        }
        NOT = {
            is_our_vassal = THIS
            has_country_modifier = neutrality_modifier
            has_country_modifier = no_more_war
            has_country_flag = in_great_war
        }
        THIS = {
            civilized = yes
            NOT = { has_country_modifier = neutrality_modifier }
        }
    }

    po_reparations = yes

    war_name = WAR_NAME_REPARATIONS

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
    }

    on_po_accepted = {
        random_owned = {
            limit = {
                owner = {
                    tag = HAI
                    FRA = { is_greater_power = yes }
                    NOT = { has_country_flag = agreed_to_pay_debt }
                }
            }
            owner = {
                country_event = 45108
            }
        }
        random_owned = {
            limit = {
                owner = {
                    tag = MEX
                    has_country_flag = pay_1st_pastry_war
                }
            }
            owner = {
                country_event = 45108
            }
        }
    }
}


# Claim Colonial Region
claim_colonial_region = {
    sprite_index = 22
    is_triggered_only = yes
    months = 12
    crisis = no

    always = yes

    construction_speed = 2.5

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.6
    penalty_factor = 2

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 6

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    can_use = {
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_flag = post_colonial_country }
        number_of_states = 2
        civilized = no
        is_vassal = no
        capital_scope = { continent = africa }
        ai = yes
        neighbour = THIS

        OR = {
            #Ghana
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ASH_1909
                            region = FRA_1907
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
            }
            #Ivory Coast
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1892
                            region = FRA_1893
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
            }
            #Nigeria
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1923
                            region = FRA_1927
                            region = FRA_1930
                            region = SOK_1934
                            region = SOK_1945
                            region = SOK_1937
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
            }
            #Guinea
            AND = {
                THIS = { any_owned_province = { region = FRA_1883 } }
                any_owned_province = { region = FRA_1883 }
            }
            #Guinea-Bissau
            AND = {
                THIS = { any_owned_province = { region = FRA_1878 } }
                any_owned_province = { region = FRA_1878 }
            }
            #Senegal
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1783
                            region = FRA_1775
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
            }
            #Mali
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1798
                            region = FRA_1801
                            region = FRA_1803
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
            }
            #Niger
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1808
                            region = FRA_1813
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
            }
            #Mozambique
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = POR_2049
                            region = POR_2054
                            region = POR_2053
                            region = POR_2060
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
            }
            #South Africa
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ENG_2087
                            region = ENG_2096
                            region = ORA_2103
                            region = TRN_2108
                            region = ZUL_2113

                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
            }
            #Angola
            AND = {
                THIS = { any_owned_province = { region = POR_1999 } }
                any_owned_province = { region = POR_1999 }
            }
            #Algiers
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ALD_1704
                            region = ALD_1713
                            region = ALD_1708
                            region = FRA_1700
                            region = ALD_1718
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Libya
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = TRI_1731
                            region = TRI_1735
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = TRI_1731
                        region = TRI_1735
                    }
                }
            }
            #Egypt
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1745
                            region = EGY_1758
                            region = EGY_1762
                            region = EGY_1771
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                        region = EGY_1755
                    }
                }
            }
            #Sudan
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1834
                            region = EGY_1827
                            region = EGY_1838
                            region = ENG_1844
                            #region = EGY_1842
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
            }
            #Ethiopia
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = ETH_1853
                            region = ETH_1852
                            region = ETH_1865
                            region = ETH_1859
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
            }
            #Somalia
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = SOM_1868
                            region = SOM_1872
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        THIS = {
            nationalism_n_imperialism = 1
            capital_scope = { continent = europe }
            NOT = { tag = RUS }
            NOT = { tag = TUR }
              NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_flag = congo_award }
            has_global_flag = berlin_conference
        }

        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = punitive_effects }
            }
        }
    }

    allowed_states = {
        any_owned_province = { any_neighbor_province = { owned_by = THIS } }
        OR = {
            #Ghana
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ASH_1909
                            region = FRA_1907
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
            }
            #Ivory Coast
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1892
                            region = FRA_1893
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
            }
            #Nigeria
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1923
                            region = FRA_1927
                            region = FRA_1930
                            region = SOK_1934
                            region = SOK_1945
                            region = SOK_1937
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
            }
            #Guinea
            AND = {
                THIS = { any_owned_province = { region = FRA_1883 } }
                any_owned_province = { region = FRA_1883 }
            }
            #Guinea-Bissau
            AND = {
                THIS = { any_owned_province = { region = FRA_1878 } }
                any_owned_province = { region = FRA_1878 }
            }
            #Senegal
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1783
                            region = FRA_1775
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
            }
            #Mali
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1798
                            region = FRA_1801
                            region = FRA_1803
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
            }
            #Niger
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = FRA_1808
                            region = FRA_1813
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
            }
            #Mozambique
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = POR_2049
                            region = POR_2054
                            region = POR_2053
                            region = POR_2060
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
            }
            #South Africa
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ENG_2087
                            region = ENG_2096
                            region = ORA_2103
                            region = TRN_2108
                            region = ZUL_2113
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
            }
            #Angola
            AND = {
                THIS = { any_owned_province = { region = POR_1999 } }
                any_owned_province = { region = POR_1999 }
            }
            #Algiers
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ALD_1704
                            region = ALD_1713
                            region = ALD_1708
                            region = FRA_1700
                            region = ALD_1718
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Libya
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = TRI_1731
                            region = TRI_1735
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = TRI_1731
                        region = TRI_1735
                    }
                }
            }
            #Egypt
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1745
                            region = EGY_1758
                            region = EGY_1762
                            region = EGY_1771
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                        region = EGY_1755
                    }
                }
            }
            #Sudan
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1834
                            region = EGY_1827
                            region = EGY_1838
                            region = ENG_1844
                            #region = EGY_1842
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
            }
            #Ethiopia
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = ETH_1853
                            region = ETH_1852
                            region = ETH_1865
                            region = ETH_1859
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
            }
            #Somalia
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = SOM_1868
                            region = SOM_1872
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
            }
        }
    }

    po_demand_state = yes

    war_name = WAR_CONCESSION_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}

# Claim Colonial Region - Annex
claim_colonial_region_full = {
    sprite_index = 22
    is_triggered_only = yes
    months = 0
    crisis = no

    construction_speed = 1.5

    badboy_factor = 0
    prestige_factor = 0.5
    peace_cost_factor = 0.6
    penalty_factor = 2

    break_truce_prestige_factor = 5
    break_truce_infamy_factor = 2
    break_truce_militancy_factor = 2
    truce_months = 6

    good_relation_prestige_factor = 0
    good_relation_infamy_factor = 0
    good_relation_militancy_factor = 0

    always = yes

    can_use = {
        NOT = { is_our_vassal = THIS }
        NOT = { has_country_flag = post_colonial_country }
        NOT = { number_of_states = 2 }
        civilized = no
        is_vassal = no
        capital_scope = { continent = africa }
        ai = yes
        neighbour = THIS

        OR = {
            #Ghana
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = ASH_1909
                            region = FRA_1907
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ASH_1909
                        region = FRA_1907
                    }
                }
            }
            #Ivory Coast
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = FRA_1892
                            region = FRA_1893
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1892
                        region = FRA_1893
                    }
                }
            }
            #Nigeria
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = FRA_1923
                            region = FRA_1927
                            region = FRA_1930
                            region = SOK_1934
                            region = SOK_1945
                            region = SOK_1937
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1923
                        region = FRA_1927
                        region = FRA_1930
                        region = SOK_1934
                        region = SOK_1945
                        region = SOK_1937
                    }
                }
            }
            #Guinea
            AND = {
                THIS = { NOT = { tag = TUR } any_owned_province = { region = FRA_1883 } }
                any_owned_province = { region = FRA_1883 }
            }
            #Guinea-Bissau
            AND = {
                THIS = { NOT = { tag = TUR } any_owned_province = { region = FRA_1878 } }
                any_owned_province = { region = FRA_1878 }
            }
            #Senegal and Mauritania
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = FRA_1783
                            region = FRA_1775
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1783
                        region = FRA_1788
                        region = FRA_1775
                    }
                }
            }
            #Mali
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = FRA_1798
                            region = FRA_1801
                            region = FRA_1803
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1798
                        region = FRA_1801
                        region = FRA_1803
                    }
                }
            }
            #Niger
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = FRA_1808
                            region = FRA_1813
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = FRA_1808
                        region = FRA_1813
                    }
                }
            }
            #Mozambique
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = POR_2049
                            region = POR_2054
                            region = POR_2053
                            region = POR_2060
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = POR_2049
                        region = POR_2054
                        region = POR_2053
                        region = POR_2060
                    }
                }
            }
            #South Africa
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = ENG_2087
                            region = ENG_2096
                            region = ORA_2103
                            region = TRN_2108
                            region = ZUL_2113
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ENG_2087
                        region = ENG_2096
                        region = ORA_2103
                        region = TRN_2108
                        region = ZUL_2113
                        region = ENG_2071
                    }
                }
            }
            #Angola
            AND = {
                NOT = { tag = TUR }
                THIS = { any_owned_province = { region = POR_1999 } }
                any_owned_province = { region = POR_1999 }
            }
            #Algiers
            AND = {
                NOT = { tag = TUR }
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = ALD_1704
                            region = ALD_1713
                            region = ALD_1708
                            region = FRA_1700
                            region = ALD_1718
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ALD_1704
                        region = ALD_1713
                        region = ALD_1708
                        region = FRA_1700
                        region = ALD_1718
                    }
                }
            }
            #Libya
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = TRI_1731
                            region = TRI_1735
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = TRI_1731
                        region = TRI_1735
                    }
                }
            }
            #Egypt
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1745
                            region = EGY_1758
                            region = EGY_1762
                            region = EGY_1771
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1745
                        region = EGY_1758
                        region = EGY_1762
                        region = EGY_1771
                        region = EGY_1755
                    }
                }
            }
            #Sudan
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = EGY_1834
                            region = EGY_1827
                            region = EGY_1838
                            region = ENG_1844
                            #region = EGY_1842
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = EGY_1834
                        region = EGY_1827
                        region = EGY_1838
                        region = ENG_1844
                        #region = EGY_1842
                    }
                }
            }
            #Ethiopia
            AND = {
                THIS = {
                    NOT = { tag = TUR }
                    any_owned_province = {
                        OR = {
                            region = ETH_1853
                            region = ETH_1852
                            region = ETH_1865
                            region = ETH_1859
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = ETH_1853
                        region = ETH_1852
                        region = ETH_1865
                        region = ETH_1859
                    }
                }
            }
            #Somalia
            AND = {
                THIS = {
                    any_owned_province = {
                        OR = {
                            region = SOM_1868
                            region = SOM_1872
                        }
                    }
                }
                any_owned_province = {
                    OR = {
                        region = SOM_1868
                        region = SOM_1872
                    }
                }
            }
        }
        OR = {
            war_with = THIS
            THIS = { military_score = 1 }
        }
        THIS = {
            nationalism_n_imperialism = 1
            capital_scope = { continent = europe }
            NOT = { tag = RUS }
              NOT = { has_country_modifier = neutrality_modifier }
            NOT = { has_country_flag = congo_award }
            has_global_flag = berlin_conference
        }

        OR = {
            war_with = THIS
            THIS = {
                NOT = { has_country_modifier = punitive_effects }
            }
        }
    }

    po_annex = yes

    war_name = WAR_PROTECTORATE_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.1
        }
    }
}


#Steal Puppet CB
steal_puppet = {
    sprite_index = 33
    is_triggered_only = yes
    months = 12

    badboy_factor = 5
    prestige_factor = 1
    peace_cost_factor = 15
    penalty_factor = 1

    break_truce_prestige_factor = 1
    break_truce_infamy_factor = 1
    break_truce_militancy_factor = 1
    truce_months = 48

    good_relation_prestige_factor = 1
    good_relation_infamy_factor = 1
    good_relation_militancy_factor = 1

    can_use = {
        OR = {
            NOT = { has_country_modifier = war_focus }
            THIS = {
                NOT = {
                    has_country_flag = exclusive_acquire_all_cores_CB
                    has_country_flag = exclusive_humiliate_CB
                    has_country_flag = exclusive_liberate_country_CB
                    has_country_flag = exclusive_make_puppet_CB
                }
            }
        }
        NOT = { is_our_vassal = THIS }
        num_of_vassals_no_substates = 1
        NOT = { has_country_modifier = neutrality_modifier }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = neutrality_modifier } }
        }
        OR = {
            war_with = THIS
            THIS = { NOT = { has_country_modifier = no_more_war } }
        }
        OR = {
            NOT = { has_country_flag = dismantle_declared }
            THIS = { NOT = { has_country_flag = in_great_war } }
            THIS = { ai = no }
        }
    }

    # THIS - us
    # FROM - country scope is possible match?
    # war target country of goal is scope
    allowed_countries = {
        is_our_vassal = FROM
        FROM = {
            is_substate = no
            NOT = { total_pops = 5000000 }
            NOT = { has_country_flag = unreleasable_country }
            OR = {
                AND = {
                    THIS = { total_amount_of_ships = 5 }
                    any_owned_province = { port = yes }
                }
                neighbour = THIS
                war_with = THIS
                any_neighbor_country = {
                    OR = {
                        vassal_of = THIS
                        substate_of = THIS
                    }
                }
            }
        }
    }

    po_release_puppet = yes
    po_add_to_sphere = yes

    war_name = WAR_NAME

    on_add = {
        move_issue_percentage = {
            from = jingoism
            to = pro_military
            value = 0.25
        }
        any_country = {
            limit = {
                exists = yes
                vassal_of = FROM
                is_substate = no
                NOT = { total_pops = 5000000 }
                NOT = { has_country_flag = unreleasable_country }
                OR = {
                    AND = {
                        THIS = { total_amount_of_ships = 5 }
                        any_owned_province = { port = yes }
                    }
                    neighbour = THIS
                    war_with = THIS
                    any_neighbor_country = {
                        OR = {
                            vassal_of = THIS
                            substate_of = THIS
                        }
                    }
                }
            }
            set_country_flag = transfer_to_new_overlord
        }
    }

    on_po_accepted = {
        THIS = { set_country_flag = new_overlord }
    }
}

# #Permanent Colonial Claims
# permanent_colonial_claim = {
    # sprite_index = 31
    # is_triggered_only = yes
    # months = 12
    # crisis = no

    # always = yes

    # construction_speed = 2.5

    # badboy_factor = 0
    # prestige_factor = 0.5
    # peace_cost_factor = 0.6
    # penalty_factor = 2

    # break_truce_prestige_factor = 5
    # break_truce_infamy_factor = 2
    # break_truce_militancy_factor = 2
    # truce_months = 0

    # good_relation_prestige_factor = 0
    # good_relation_infamy_factor = 0
    # good_relation_militancy_factor = 0

    # can_use = {
        # NOT = { is_our_vassal = THIS }
        # NOT = { in_sphere = THIS }
        # OR = {
            # war_with = THIS
            # THIS = {
                # NOT = { has_country_modifier = punitive_effects }
            # }
        # }
        # OR = {
            # NOT = { has_country_flag = post_colonial_country }
            # civilized = no
        # }
        # any_owned_province = { is_core = CNG }
        # THIS = {
            # has_country_flag = congo_master
        # }
        # OR = {
            # war_with = THIS
            # THIS = { military_score = 1 }
        # }
    # }

    # allowed_states = {
        # any_owned_province = { is_core = CNG }
        # THIS = { has_country_flag = congo_master }
    # }

    # po_demand_state = yes

    # war_name = WAR_CONCESSION_NAME

    # on_add = {
        # move_issue_percentage = {
            # from = jingoism
            # to = pro_military
            # value = 0.1
        # }
    # }
# }
END
