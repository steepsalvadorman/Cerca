use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct ClientAddress {
    pub id: Uuid,
    pub client_id: Uuid,
    pub label: String,
    pub detail: String,
}

impl ClientAddress {
    pub fn new(client_id: Uuid, label: String, detail: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            client_id,
            label,
            detail,
        }
    }
}
