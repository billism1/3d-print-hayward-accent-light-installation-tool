// ============================================================
// Hayward ColorLogic Accent Light Installation Tool – End Piece
// ============================================================

// ----- Constants & Parameters -----
disc_diameter   = 29;     // mm – outer diameter of the circular end
disc_thickness  = 2;      // mm – depth (Z) of the flat disc

prong_height    = 2;      // mm – how far prongs extend above the disc
prong_arc_len   = 3.5;      // mm – arc length of each prong along circumference
prong_width     = 2;      // mm – radial thickness of each prong (adjustable)
prong_count     = 3;

// ----- Derived Dimensions -----
disc_radius     = disc_diameter / 2;
prong_arc_angle = (prong_arc_len / (PI * disc_diameter)) * 360; // degrees
eps             = 0.01;   // mm – tiny overlap to avoid z-fighting

// ----- Quality -----
$fn = 180;

// ----- Component Modules -----

module disc() {
    cylinder(d = disc_diameter, h = disc_thickness);
}

module prong() {
    rotate_extrude(angle = prong_arc_angle)
        translate([disc_radius - prong_width, 0])
            square([prong_width, prong_height + eps]);
}

module prongs() {
    for (i = [0 : prong_count - 1])
        rotate([0, 0, i * (360 / prong_count) - prong_arc_angle / 2])
            translate([0, 0, disc_thickness - eps])
                prong();
}

// ----- Assembly -----
disc();
prongs();
