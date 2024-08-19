// Worlgen Constants
pub const VIEW_WIDTH: usize = 110;
pub const VIEW_HEIGHT: usize = 32;

pub const ROOM_X: usize = 3;
pub const ROOM_Y: usize = 3;

pub const WORLD_WIDTH = VIEW_WIDTH * ROOM_X;
pub const WORLD_HEIGHT = VIEW_HEIGHT * ROOM_Y;

pub const ENTITY_LIMIT: usize = 256;

pub const LAYERS: usize = 10;

// FOV Constants
pub const VIEW_FOV: usize = 100;
pub const VIEW_RADIUS: usize = 50;

// UI Constants
pub const VIEWBOX_WIDTH: usize = VIEW_WIDTH + 1;
pub const VIEWBOX_HEIGHT: usize = VIEW_HEIGHT + 1;

pub const UI_GAP: usize = 2;

pub const UI_SIDEBAR_WIDTH: usize = 32;
pub const UI_MESSAGE_HEIGHT: usize = 9;

pub const UI_WIDTH = VIEWBOX_WIDTH + UI_GAP + UI_SIDEBAR_WIDTH;
pub const UI_HEIGHT = VIEWBOX_HEIGHT + UI_GAP + UI_MESSAGE_HEIGHT;

pub const UI_MAX_MESSAGES: usize = 16;
