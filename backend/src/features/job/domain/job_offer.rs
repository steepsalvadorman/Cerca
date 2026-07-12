use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct JobOffer {
    pub id: i32,
    pub job_request_id: Uuid,
    pub technician_profile_id: i32,
    pub price: i32,
    pub eta: String,
    pub name: String,     // Joined from user name
    pub mono: String,     // Initials
    pub oficio: String,   // Technician specialty
    pub rating: f64,      // Technician rating
    pub verified: bool,   // Technician verification status
}
