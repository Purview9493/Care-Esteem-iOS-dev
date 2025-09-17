//
//  CarePlanResponse.swift
//  CareEsteem
//
//  Created by Gaurav Agnihotri on 30/08/25.
//


import Foundation

// MARK: - Top level response
struct CarePlanResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [CarePlanData]
}

// MARK: - Data wrapper
struct CarePlanData: Codable {
    let activityAssessment: [AssessmentSection]?
    let environmentAssessment: [AssessmentSection]?
    let financialAssessment: [AssessmentSection]?
    let mentalHealthAssessment: [AssessmentSection]?
    let communicationAssessment: [AssessmentSection]?
    let personalHygieneAssessment: [AssessmentSection]?
    let medicationAssessment: [AssessmentSection]?
    let clinicalAssessment: [AssessmentSection]?
    let culturalSpiritualSocialRelationshipsAssessment: [AssessmentSection]?
    let behaviourAssessment: [AssessmentSection]?
    let oralCareAssessment: [AssessmentSection]?
    let breathingAssessment: [AssessmentSection]?
    let continenceAssessment: [AssessmentSection]?
    let domesticAssessment: [AssessmentSection]?
    let equipmentAssessment: [AssessmentSection]?
    let movingHandlingAssessment: [AssessmentSection]?
    let painAssessment: [AssessmentSection]?
    let sleepingAssessment: [AssessmentSection]?
    let skinAssessment: [AssessmentSection]?
    let nutritionHydrationAssessment: [AssessmentSection]?
    
    enum CodingKeys: String, CodingKey {
        case activityAssessment = "ActivityAssessment"
        case environmentAssessment = "EnvironmentAssessment"
        case financialAssessment = "FinancialAssessment"
        case mentalHealthAssessment = "MentalHealthAssessment"
        case communicationAssessment = "CommunicationAssessment"
        case personalHygieneAssessment = "PersonalHygieneAssessment"
        case medicationAssessment = "MedicationAssessment"
        case clinicalAssessment = "ClinicalAssessment"
        case culturalSpiritualSocialRelationshipsAssessment = "CulturalSpiritualSocialRelationshipsAssessment"
        case behaviourAssessment = "BehaviourAssessment"
        case oralCareAssessment = "OralCareAssessment"
        case breathingAssessment = "BreathingAssessment"
        case continenceAssessment = "ContinenceAssessment"
        case domesticAssessment = "DomesticAssessment"
        case equipmentAssessment = "EquipmentAssessment"
        case movingHandlingAssessment = "MovingHandlingAssessment"
        case painAssessment = "PainAssessment"
        case sleepingAssessment = "SleepingAssessment"
        case skinAssessment = "SkinAssessment"
        case nutritionHydrationAssessment = "NutritionHydrationAssessment"
    }
}

// MARK: - Assessment section
struct AssessmentSection: Codable {
    let consent: Bool
    let closeDate: String
    let questions: [AssessmentQuestion]
}

// MARK: - Each Question
struct AssessmentQuestion: Codable {
    let questionNo: Int
    let questionName: String
    let status: String
    let comment: String
}

// MARK: - UI Helper Model
struct CarePlanSectionUI {
    let title: String
    let questions: [AssessmentQuestion]
}

// MARK: - Mapper
extension CarePlanData {
    func toSections() -> [CarePlanSectionUI] {
        var result: [CarePlanSectionUI] = []
        
        if let activity = activityAssessment {
            result.append(CarePlanSectionUI(title: "Activity Assessment", questions: activity.first?.questions ?? []))
        }
        if let env = environmentAssessment {
            result.append(CarePlanSectionUI(title: "Environment Assessment", questions: env.first?.questions ?? []))
        }
        if let finance = financialAssessment {
            result.append(CarePlanSectionUI(title: "Financial Assessment", questions: finance.first?.questions ?? []))
        }
        if let mental = mentalHealthAssessment {
            result.append(CarePlanSectionUI(title: "Mental Health Assessment", questions: mental.first?.questions ?? []))
        }
        if let communication = communicationAssessment {
            result.append(CarePlanSectionUI(title: "Communication Assessment", questions: communication.first?.questions ?? []))
        }
        if let personal = personalHygieneAssessment {
            result.append(CarePlanSectionUI(title: "Personal Hygiene Assessment", questions: personal.first?.questions ?? []))
        }
        if let medication = medicationAssessment {
            result.append(CarePlanSectionUI(title: "Medication Assessment", questions: medication.first?.questions ?? []))
        }
        if let clinical = clinicalAssessment {
            result.append(CarePlanSectionUI(title: "Clinical Assessment", questions: clinical.first?.questions ?? []))
        }
        if let culture = culturalSpiritualSocialRelationshipsAssessment {
            result.append(CarePlanSectionUI(title: "Cultural/Spiritual/Social Assessment", questions: culture.first?.questions ?? []))
        }
        if let behaviour = behaviourAssessment {
            result.append(CarePlanSectionUI(title: "Behaviour Assessment", questions: behaviour.first?.questions ?? []))
        }
        if let oral = oralCareAssessment {
            result.append(CarePlanSectionUI(title: "Oral Care Assessment", questions: oral.first?.questions ?? []))
        }
        if let breathing = breathingAssessment {
            result.append(CarePlanSectionUI(title: "Breathing Assessment", questions: breathing.first?.questions ?? []))
        }
        if let continence = continenceAssessment {
            result.append(CarePlanSectionUI(title: "Continence Assessment", questions: continence.first?.questions ?? []))
        }
        if let domestic = domesticAssessment {
            result.append(CarePlanSectionUI(title: "Domestic Assessment", questions: domestic.first?.questions ?? []))
        }
        if let equipment = equipmentAssessment {
            result.append(CarePlanSectionUI(title: "Equipment Assessment", questions: equipment.first?.questions ?? []))
        }
        if let moving = movingHandlingAssessment {
            result.append(CarePlanSectionUI(title: "Moving & Handling Assessment", questions: moving.first?.questions ?? []))
        }
        if let pain = painAssessment {
            result.append(CarePlanSectionUI(title: "Pain Assessment", questions: pain.first?.questions ?? []))
        }
        if let sleeping = sleepingAssessment {
            result.append(CarePlanSectionUI(title: "Sleeping Assessment", questions: sleeping.first?.questions ?? []))
        }
        if let skin = skinAssessment {
            result.append(CarePlanSectionUI(title: "Skin Assessment", questions: skin.first?.questions ?? []))
        }
        if let nutrition = nutritionHydrationAssessment {
            result.append(CarePlanSectionUI(title: "Nutrition & Hydration Assessment", questions: nutrition.first?.questions ?? []))
        }
        
        return result
    }
}
