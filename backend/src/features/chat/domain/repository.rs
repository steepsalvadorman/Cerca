use async_trait::async_trait;
use uuid::Uuid;

use super::errors::ChatError;
use super::message::ChatMessage;

#[async_trait]
pub trait ChatRepository: Send + Sync {
    async fn add_message(&self, message: &ChatMessage) -> Result<(), ChatError>;
    async fn find_messages_by_job_id(&self, job_request_id: Uuid) -> Result<Vec<ChatMessage>, ChatError>;
}
