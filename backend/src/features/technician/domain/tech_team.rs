#[derive(Debug, Clone)]
pub struct TechTeam {
    pub id: i32,
    pub name: String,
    pub mono: String,
    pub oficio: String,
    pub rating: f64,
    pub reviews: i32,
    pub distance: String,
    pub price_label: String,
    pub pin_top: f64,
    pub pin_left: f64,
    pub crew: i32,
    pub projects: i32,
    pub labor_cost: i32,
    pub materials_cost: i32,
    pub mobility_cost: i32,
}
