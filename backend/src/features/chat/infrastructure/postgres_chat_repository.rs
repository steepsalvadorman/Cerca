use async_trait::async_trait;
use chrono::{DateTime, Utc};
use sqlx::PgPool;
use uuid::Uuid;

use crate::features::chat::domain::{ChatError, ChatMessage, ChatRepository};

#[derive(sqlx::FromRow)]
struct ChatMessageRow {
    id: Uuid,
    job_request_id: Uuid,
    sender_id: Uuid,
    sender_role: String,
    text: String,
    created_at: DateTime<Utc>,
}

impl From<ChatMessageRow> for ChatMessage {
    fn from(row: ChatMessageRow) -> Self {
        Self {
            id: row.id,
            job_request_id: row.job_request_id,
            sender_id: row.sender_id,
            sender_role: row.sender_role,
            text: row.text,
            created_at: row.created_at,
        }
    }
}

pub struct PostgresChatRepository {
    pool: PgPool,
}

impl PostgresChatRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl ChatRepository for PostgresChatRepository {
    async fn add_message(&self, message: &ChatMessage) -> Result<(), ChatError> {
        sqlx::query(
            "INSERT INTO chat_messages (id, job_request_id, sender_id, sender_role, text, created_at) \
             VALUES ($1, $2, $3, $4, $5, $6)",
        )
        .bind(message.id)
        .bind(message.job_request_id)
        .bind(message.sender_id)
        .bind(&message.sender_role)
        .bind(&message.text)
        .bind(message.created_at)
        .execute(&self.pool)
        .await
        .map_err(|e| ChatError::Repository(e.to_string()))?;

        Ok(())
    }

    async fn find_messages_by_job_id(&self, job_request_id: Uuid) -> Result<Vec<ChatMessage>, ChatError> {
        let rows = sqlx::query_as::<_, ChatMessageRow>(
            "SELECT id, job_request_id, sender_id, sender_role, text, created_at \
             FROM chat_messages WHERE job_request_id = $1 ORDER BY created_at ASC",
        )
        .bind(job_request_id)
        .fetch_all(&self.pool)
        .await
        .map_err(|e| ChatError::Repository(e.to_string()))?;

        Ok(rows.into_iter().map(ChatMessage::from).collect())
    }
}
