//
//  Article.swift
//  CluckChecker
//
//  Created by Адам Табиев on 24.07.2025.
//

import Foundation

struct Article: Identifiable {
    let id: Int
    let image: String
    let title: String
    let text: String
}

struct articleData {
    static let articles: [Article] = [
        Article(
            id: 0,
            image: "article1Image",
            title: "Feeding Chickens: Basics of a Proper Diet",
            text: """
Proper nutrition is the key to healthy and productive chickens. The diet should primarily consist of grains such as wheat, corn, and barley. Grains make up about 60–70% of the daily feed.

To ensure proper development and good egg production, chickens need sufficient protein. Sources include fish meal, cottage cheese, boiled eggs, and legumes. Mineral supplements like crushed shells and oyster grit provide calcium, essential for strong eggshells.

Greens and vegetables (nettles, dandelions, carrots, pumpkin) supply vitamins and add variety to the diet. Feed chickens twice a day, maintaining a consistent schedule, and always provide fresh feed and clean water.
"""
        ),
        Article(
            id: 1,
            image: "article2Image",
            title: "Seasonal Feeding Schedule for Chickens",
            text: """
Feeding chickens according to the season ensures their health and productivity year-round. In spring and summer, provide fresh greens, insects, and protein-rich supplements to support egg-laying and molting. Chickens are more active and need additional nutrients.

In autumn, gradually transition to more grains and seeds to help birds gain weight before winter. Include vitamin-rich vegetables like squash and carrots.

During winter, chickens require higher energy intake. Offer warm mash, corn, and protein supplements to maintain body temperature and egg production. Reduce wet or frozen feed, and ensure constant access to clean, unfrozen water.

Adjusting the feed seasonally helps avoid deficiencies, supports immune function, and ensures consistent egg quality throughout the year.
"""
        ),
        Article(
            id: 2,
            image: "article3Image",
            title: "Egg Production: How to Improve Productivity",
            text: """
Maximizing egg production requires a combination of proper nutrition, lighting, and stress-free conditions. Feed should be rich in calcium, protein, and essential minerals. Use layer feed that includes oyster shells or crushed limestone for strong eggshells.

Maintain a regular light schedule—chickens need 14–16 hours of light daily for optimal laying. Supplement with artificial lighting during shorter winter days.

Keep the coop clean and dry, with adequate nesting boxes and minimal noise or stress. Avoid overcrowding and ensure enough space per bird.

Regularly check for parasites, monitor laying patterns, and isolate sick hens early. Consistent care and a balanced diet can significantly boost both the quantity and quality of eggs.
"""
        ),
        Article(
            id: 3,
            image: "article4Image",
            title: "Disease Prevention for Chickens",
            text: """
Preventing disease is crucial for maintaining a healthy flock. Begin with clean housing—remove droppings daily, replace bedding regularly, and ensure proper ventilation.

Provide clean water at all times and avoid feed spoilage. Use feeders and drinkers that prevent contamination. Introduce new birds only after a quarantine period of at least 2 weeks.

Regularly inspect chickens for parasites (mites, lice) and treat them promptly. Deworming may be necessary every few months, depending on your region.

Vaccination against common diseases such as Marek’s disease or Newcastle disease is recommended. A healthy diet, low-stress environment, and biosecurity measures are your best defense against infections.
"""
        ),
        Article(
            id: 4,
            image: "article5Image",
            title: "Chicken Housing: Comfort and Safety",
            text: """
A safe and comfortable coop is essential for happy, productive chickens. Ensure the housing is dry, insulated, and well-ventilated, protecting birds from cold, heat, and drafts.

Use straw or wood shavings as bedding, and change it regularly. Provide one nesting box per 3–4 hens, keeping them clean and slightly darkened for comfort.

Roosting bars should be placed off the ground, allowing chickens to perch at night. Protect the coop with secure fencing to keep out predators like foxes, dogs, or birds of prey.

Install automatic doors or locks, and make sure the coop is easy to clean. Proper lighting, spacing, and security contribute to overall health, reduced stress, and better egg-laying.
"""
        )
    ]
}
