use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct TechnicianProfile {
    pub id: i32,
    pub user_id: Uuid,
    pub name: String, // Joined from users table
    pub mono: String, // Generated from name (initials)
    pub oficio: String,
    pub rating: f64,
    pub reviews: i32,
    pub distance: String,
    pub price_label: String,
    pub pin_top: f64,
    pub pin_left: f64,
    pub coverage_km: i32,
    pub available_days: Vec<String>,
    pub categories: Vec<String>,
    pub is_verified: bool,
}

impl TechnicianProfile {
    pub fn get_mono(name: &str) -> String {
        let parts: Vec<&str> = name.split_whitespace().collect();
        if parts.is_empty() {
            "?".to_string()
        } else if parts.len() == 1 {
            parts[0].chars().take(2).collect::<String>().to_uppercase()
        } else {
            let first = parts[0].chars().next().unwrap_or('?');
            let second = parts[1].chars().next().unwrap_or('?');
            format!("{}{}", first, second).to_uppercase()
        }
    }
}
