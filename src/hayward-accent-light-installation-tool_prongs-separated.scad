// ============================================================
// Hayward ColorLogic Accent Light Installation Tool – End Piece
// ============================================================

// ----- Constants & Parameters -----
disc_diameter   = 30;     // mm – outer diameter of the circular end
disc_thickness  = 15;     // mm – depth (Z) of the flat disc

prong_height    = 2;      // mm – how far prongs extend above the disc
prong_arc_len   = 4;    // mm – arc length of each prong along circumference
prong_count     = 3;
prong_insert    = 5;      // mm – depth of prong tab that inserts into the disc
prong_clearance = 0.15;   // mm – clearance per side for prong slot in disc

// Concave dish on top of disc (to cradle convex light fixture)
dish_depth      = 3;      // mm – how deep the concavity is

// Render toggles
render_end_piece    = true;
render_handle       = true;
render_prongs       = true;
render_single_prong = false;  // true = render only 1 prong for printing

// Handle parameters
handle_diameter = 24;     // mm
handle_length   = 80;     // mm
handle_gap      = 2;      // mm – visual gap between handle and disc

// Handle neck parameters
neck_start      = 12;     // mm – distance from top of handle to start of neck
neck_diameter   = 17;     // mm – narrowed diameter
neck_length     = 15;     // mm – length of the narrow section
neck_taper      = 6;      // mm – length of each conical transition

// Interlocking tab parameters
tab_count       = 3;
tab_width       = 5;      // mm – width tangentially
tab_depth       = 4;      // mm – radial depth of each tab
tab_height      = 6;      // mm – how far tabs protrude into the disc
tab_radial_pos  = 8;      // mm – distance from center to tab center
tab_clearance   = 0.35;   // mm – press-fit tolerance per side

// ----- Derived Dimensions -----
disc_radius     = disc_diameter / 2;
handle_radius   = handle_diameter / 2;
prong_arc_angle = (prong_arc_len / (PI * disc_diameter)) * 360; // degrees
eps             = 0.01;   // mm – tiny overlap to avoid z-fighting

// Slot dimensions (tab + clearance on each side)
slot_width      = tab_width + 2 * tab_clearance;
slot_depth      = tab_depth + 2 * tab_clearance;

// ----- Quality -----
$fn = 80;

// ----- Component Modules -----

module disc() {
    cylinder(d1 = disc_diameter, d2 = disc_diameter, h = disc_thickness);
}

// Prong cross-section (lens shape from above)
module prong_profile(h) {
    half_arc = prong_arc_len / 2;
    intersection() {
        translate([disc_radius, 0, 0])
            cylinder(r = half_arc, h = h);
        cylinder(r = disc_radius, h = h);
    }
}

// Full prong: visible part + insertion tab below
module prong_with_tab() {
    prong_total_h = prong_height + dish_depth + eps;
    // Visible prong part
    prong_profile(prong_total_h);
    // Insertion tab extending downward into the disc
    translate([0, 0, -prong_insert])
        prong_profile(prong_insert);
}

// All prongs positioned on the disc (for preview)
module prongs_on_disc() {
    for (i = [0 : prong_count - 1])
        rotate([0, 0, i * (360 / prong_count)])
            translate([0, 0, disc_thickness - dish_depth - eps])
                prong_with_tab();
}

// Prong slot cutout (slightly larger than prong for clearance)
// Extends from insertion depth all the way through the top so prongs insert from above
module prong_slot() {
    slot_total_h = prong_insert + dish_depth + eps;
    half_arc = prong_arc_len / 2 + prong_clearance;
    intersection() {
        translate([disc_radius, 0, 0])
            cylinder(r = half_arc, h = slot_total_h);
        cylinder(r = disc_radius + prong_clearance, h = slot_total_h);
    }
}

// All prong slots cut into the disc – open from the top
module prong_slots() {
    for (i = [0 : prong_count - 1])
        rotate([0, 0, i * (360 / prong_count)])
            translate([0, 0, disc_thickness - dish_depth - prong_insert])
                prong_slot();
}

// Individual prongs positioned just outside the disc near their respective slots
module prongs_for_printing() {
    prong_gap = 4;  // mm – gap between disc outer edge and prong outer edge
    prong_render_count = render_single_prong ? 1 : prong_count;
    for (i = [0 : prong_render_count - 1])
        rotate([0, 0, i * (360 / prong_count)])
            translate([prong_gap, 0, disc_thickness - dish_depth])
                prong_with_tab();
}

// Cutout slots in the bottom of the disc for the handle tabs
module disc_slots() {
    for (i = [0 : tab_count - 1])
        rotate([0, 0, i * (360 / tab_count)])
            translate([tab_radial_pos - slot_depth / 2,
                       -slot_width / 2,
                       -eps])
                cube([slot_depth, slot_width, tab_height + eps]);
}

// Spherical concave dish cut from the top of the disc
module dish_cutout() {
    // Sphere radius derived so that a cap of dish_depth has the disc's radius as chord
    dish_r = (disc_radius * disc_radius + dish_depth * dish_depth) / (2 * dish_depth) - 2;
    translate([0, 0, disc_thickness - dish_depth + dish_r])
        sphere(r = dish_r);
}

// The disc with all slots cut out (handle tabs + prong slots + dish)
module end_piece() {
    difference() {
        disc();
        disc_slots();
        dish_cutout();
        prong_slots();
    }
}

// Tabs that protrude from the top of the handle
module handle_tabs() {
    for (i = [0 : tab_count - 1])
        rotate([0, 0, i * (360 / tab_count)])
            translate([tab_radial_pos - tab_depth / 2,
                       -tab_width / 2,
                       handle_length])
                cube([tab_depth - tab_clearance, tab_width - tab_clearance, tab_height]);
}

module handle() {
    neck_bottom = handle_length - neck_start - neck_taper - neck_length - neck_taper;
    // Top section: full diameter
    translate([0, 0, handle_length - neck_start])
        cylinder(d = handle_diameter, h = neck_start);
    // Upper taper: handle_diameter -> neck_diameter
    translate([0, 0, handle_length - neck_start - neck_taper])
        cylinder(d1 = neck_diameter, d2 = handle_diameter, h = neck_taper);
    // Narrow neck section
    translate([0, 0, handle_length - neck_start - neck_taper - neck_length])
        cylinder(d = neck_diameter, h = neck_length);
    // Lower taper: handle_diameter -> neck_diameter
    translate([0, 0, neck_bottom])
        cylinder(d1 = handle_diameter, d2 = neck_diameter, h = neck_taper);
    // Bottom section: full diameter
    cylinder(d = handle_diameter, h = neck_bottom);
    handle_tabs();
}

// ----- Assembly -----
if (render_end_piece)
    end_piece();

if (render_prongs)
    prongs_for_printing();

if (render_handle)
    translate([0, 0, -(handle_length + tab_height + handle_gap)])
        handle();
