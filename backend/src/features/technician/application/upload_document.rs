use std::sync::Arc;
use uuid::Uuid;

use crate::features::technician::domain::{DocStatus, TechnicianError, TechnicianRepository};

pub struct ToggleDocumentInput {
    pub user_id: Uuid,
    pub document_key: String,
    pub status: DocStatus,
}

pub struct ToggleDocumentUseCase {
    technician_repo: Arc<dyn TechnicianRepository>,
}

impl ToggleDocumentUseCase {
    pub fn new(technician_repo: Arc<dyn TechnicianRepository>) -> Self {
        Self { technician_repo }
    }

    pub async fn execute(&self, input: ToggleDocumentInput) -> Result<(), TechnicianError> {
        let profile = self.technician_repo
            .find_profile_by_user_id(input.user_id)
            .await?
            .ok_or(TechnicianError::TechnicianNotFound)?;

        self.technician_repo
            .update_document_status(profile.id, &input.document_key, input.status)
            .await?;

        // If all mandatory documents are uploaded, we can optionally mark the technician as verified.
        // We have 4 document requirements: 'cedula', 'antecedentes', 'especialidad', 'seguro'.
        // Let's check if all (excluding optional 'seguro') or all 4 are uploaded.
        // If 'cedula', 'antecedentes', 'especialidad' are uploaded, they are verified.
        let docs = self.technician_repo.find_documents(profile.id).await?;
        let mandatory_uploaded = docs.iter()
            .filter(|d| d.document_key != "seguro")
            .all(|d| d.status == DocStatus::Uploaded);

        // Update verification status in profile if mandatory are uploaded
        if mandatory_uploaded && docs.len() >= 3 {
            let mut updated_profile = profile;
            updated_profile.is_verified = true;
            self.technician_repo.save_profile(&updated_profile).await?;
        }

        Ok(())
    }
}
