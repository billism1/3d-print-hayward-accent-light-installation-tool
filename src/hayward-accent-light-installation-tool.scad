// ============================================================
// Hayward ColorLogic Accent Light Installation Tool – End Piece
// ============================================================

// ----- Constants & Parameters -----
disc_diameter   = 30;     // mm – outer diameter of the circular end
disc_thickness  = 15;     // mm – depth (Z) of the flat disc

prong_height    = 2;      // mm – how far prongs extend above the disc
prong_arc_len   = 4;    // mm – arc length of each prong along circumference
prong_count     = 3;

// Concave dish on top of disc (to cradle convex light fixture)
dish_depth      = 3;      // mm – how deep the concavity is

// Render toggles
render_end_piece  = true;
render_handle     = true;
render_grip_collar = true;
render_combined   = true;  // true = union end piece + handle as one solid object

// Handle parameters
handle_diameter = 24;     // mm
handle_length   = 80;     // mm
handle_gap      = 2;      // mm – visual gap between handle and disc

// Handle neck parameters
neck_start      = 12;     // mm – distance from top of handle to start of neck
neck_diameter   = 17;     // mm – narrowed diameter
neck_length     = 15;     // mm – length of the narrow section
neck_taper      = 6;      // mm – length of each conical transition

// Grip collar parameters
collar_inner_diameter  = 32;     // mm – inside diameter (end piece sits inside)
collar_base_thickness  = 10;     // mm – base ring wall thickness at top
collar_base_thickness_bottom = 4; // mm – base ring wall thickness at bottom
collar_tooth_thickness = 10;     // mm – additional thickness for gear-tooth region
collar_height          = 22;     // mm – height when printed flat on bed
collar_tooth_count     = 6;      // number of gear-like grip teeth
collar_ledge_width     = 10;     // mm – radial width of the prong ledge ring on top
collar_ledge_height    = 3;      // mm – height the ledge extrudes above the collar
collar_tooth_taper_h   = 13;     // mm – height of 45° taper on bottom of teeth (= tooth thickness)

// Collar lip parameters (retention lip on bottom inside)
collar_lip_height      = 2;      // mm – height of the lip
collar_lip_thickness   = 2;      // mm – radial extent inward from inner diameter

// Collar prong parameters
collar_prong_height    = 3.5;    // mm – height of prongs above the ledge
collar_prong_thickness = 2.5;    // mm – wall thickness of each prong arc
collar_prong_count     = 3;      // number of prongs, evenly spaced
collar_prong_ring_od   = 100;    // mm – outer diameter of the hypothetical ring defining arc curvature
collar_prong_length    = 5;      // mm – radial length of each prong arc

// Interlocking tab parameters
tab_count       = 3;
tab_width       = 5;      // mm – width tangentially
tab_depth       = 4;      // mm – radial depth of each tab
tab_height      = 6;      // mm – how far tabs protrude into the disc
tab_radial_pos  = 8;      // mm – distance from center to tab center
tab_clearance   = render_combined ? 0.0 : 0.35;   // mm – press-fit tolerance per side (0 when combined)

// ----- Derived Dimensions -----
disc_radius     = disc_diameter / 2;
handle_radius   = handle_diameter / 2;
prong_arc_angle = (prong_arc_len / (PI * disc_diameter)) * 360; // degrees
eps             = 0.01;   // mm – tiny overlap to avoid z-fighting

// Slot dimensions (tab + clearance on each side)
slot_width      = tab_width + 2 * tab_clearance;
slot_depth      = tab_depth + 2 * tab_clearance;

// Grip collar derived dimensions
collar_inner_radius = collar_inner_diameter / 2;
collar_total_thickness = collar_base_thickness + collar_tooth_thickness;
collar_outer_radius = collar_inner_radius + collar_total_thickness;  // full outer radius including teeth
collar_base_outer_radius = collar_inner_radius + collar_base_thickness; // outer radius of base ring at top
collar_base_outer_radius_bottom = collar_inner_radius + collar_base_thickness_bottom; // outer radius of base ring at bottom
collar_outer_radius_bottom = collar_base_outer_radius_bottom + collar_tooth_thickness; // full outer radius at bottom
collar_cutout_radius = collar_tooth_thickness;  // radius of each semicircular cutout

// Collar prong derived dimensions
collar_prong_ring_or = collar_prong_ring_od / 2;                       // 50 mm
collar_prong_ring_ir = collar_prong_ring_or - collar_prong_thickness;  // 47.5 mm
// Ring center placed so the arc is at the radial center of the ledge,
// with tangent in the radial direction (perpendicular to circumference).
collar_prong_mid_r = collar_inner_radius + collar_ledge_width / 2;
collar_prong_inset = (collar_ledge_width - collar_prong_length) / 2;  // radial offset to center prongs on ledge

// ----- Quality -----
$fn = 180;

// ----- Component Modules -----

disc_taper_height = 1;    // mm – height of conical taper at bottom of disc

module disc() {
    // Bottom cone: tapers from handle_diameter up to disc_diameter
    cylinder(d1 = handle_diameter, d2 = disc_diameter, h = disc_taper_height);
    // Remaining straight cylinder
    translate([0, 0, disc_taper_height])
        cylinder(d = disc_diameter, h = disc_thickness - disc_taper_height);
}

module prong() {
    prong_total_h = prong_height + dish_depth + eps;
    half_arc = prong_arc_len / 2;

    // Lens shape from above: outer follows disc curvature, inner is convex toward center
    intersection() {
        // Cylinder centered on disc edge along +X
        translate([disc_radius, 0, 0])
            cylinder(r = half_arc, h = prong_total_h);
        // Clip to inside the disc radius
        cylinder(r = disc_radius, h = prong_total_h);
    }
}

module prongs() {
    for (i = [0 : prong_count - 1])
        rotate([0, 0, i * (360 / prong_count)])
            translate([0, 0, disc_thickness - dish_depth - eps])
                prong();
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

// The disc with slots and concave dish cut out
module end_piece() {
    difference() {
        disc();
        disc_slots();
        dish_cutout();
    }
    prongs();
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

// ----- Grip Collar Module -----

// Ring with gear-like teeth for grip; the end piece fits inside.
// Built as a thick ring with semicircular cutouts along the exterior.
module grip_collar() {
    // Main collar body with gear teeth
    difference() {
        // Full-thickness tapered ring (base + tooth region)
        difference() {
            cylinder(r1 = collar_outer_radius_bottom, r2 = collar_outer_radius, h = collar_height);
            translate([0, 0, -eps])
                cylinder(r = collar_inner_radius, h = collar_height + 2 * eps);
        }
        // Cut 6 semicircular notches evenly around the exterior
        for (i = [0 : collar_tooth_count - 1])
            rotate([0, 0, i * (360 / collar_tooth_count) + (360 / collar_tooth_count / 2)])
                translate([collar_outer_radius, 0, -eps])
                    cylinder(r = collar_cutout_radius, h = collar_height + 2 * eps);
        // 45° taper on bottom of teeth – slopes inward to print without support
        translate([0, 0, -eps])
            difference() {
                cylinder(r = collar_outer_radius + eps, h = collar_tooth_taper_h + eps);
                cylinder(r1 = collar_base_outer_radius_bottom, r2 = collar_outer_radius,
                         h = collar_tooth_taper_h + eps);
            }
    }
    // Retention lip: ring on bottom inside of collar
    difference() {
        cylinder(r = collar_inner_radius, h = collar_lip_height);
        translate([0, 0, -eps])
            cylinder(r = collar_inner_radius - collar_lip_thickness, h = collar_lip_height + 2 * eps);
    }
    // Prong ledge: ring on top (+Z) surface for arced prongs
    translate([0, 0, collar_height])
        difference() {
            cylinder(r = collar_inner_radius + collar_ledge_width, h = collar_ledge_height);
            translate([0, 0, -eps])
                cylinder(r = collar_inner_radius, h = collar_ledge_height + 2 * eps);
        }
    // Arced prongs on top of the ledge
    collar_prongs();
}

// A single prong arc: a short radial arc perpendicular to the collar circumference.
// The hypothetical ring is centered tangentially (along Y) so its arc crosses the
// ledge in the radial (+X) direction, then clipped to collar_prong_length.
// A narrow Y-band clip keeps only the single arc at the bottom of the ring.
module collar_prong() {
    intersection() {
        // Ring centered above the prong midpoint so the arc is radial
        translate([collar_prong_mid_r, collar_prong_ring_or, 0])
            difference() {
                cylinder(r = collar_prong_ring_or, h = collar_prong_height);
                translate([0, 0, -eps])
                    cylinder(r = collar_prong_ring_ir, h = collar_prong_height + 2 * eps);
            }
        // Clip to an annular band: centered on ledge
        difference() {
            cylinder(r = collar_inner_radius + collar_prong_inset + collar_prong_length, h = collar_prong_height);
            translate([0, 0, -eps])
                cylinder(r = collar_inner_radius + collar_prong_inset, h = collar_prong_height + 2 * eps);
        }
        // Clip Y to keep only the single arc near Y=0
        translate([0, -collar_prong_thickness, 0])
            cube([collar_inner_radius + collar_prong_inset + collar_prong_length + eps,
                  collar_prong_thickness * 2,
                  collar_prong_height]);
    }
}

module collar_prongs() {
    for (i = [0 : collar_prong_count - 1])
        rotate([0, 0, i * (360 / collar_prong_count)])
            translate([0, 0, collar_height + collar_ledge_height])
                collar_prong();
}

// ----- Assembly -----
if (render_combined) {
    union() {
        end_piece();
        translate([0, 0, -(handle_length)])
            handle();
    }
} else {
    if (render_end_piece)
        end_piece();

    if (render_handle)
        translate([0, 0, -(handle_length + tab_height + handle_gap)])
            handle();
}

if (render_grip_collar)
    translate([collar_outer_radius + disc_radius + 10, 0, 0])
        grip_collar();
