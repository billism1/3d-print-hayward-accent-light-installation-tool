# Hayward ColorLogic Accent Light Installation & Removal Tool

A 3D-Printable Replacement for the Hayward SP0536CTOOL

Yeah, so the Hayward provided tool for replacing ColorLogic accent lights broke mid-removal, with the light still in the wall. Could have ordered another one and waited. Instead I broke a few prototypes, reinforcing what I already know about FDM layer orientation: it actually matters for small pieces, and ended up with a tool that survived the job. Three print profiles below: two for the hand tool (pick by how much epoxy you feel like dealing with), plus a separate one for the grip collar if yours broke too.

This is a 3D-printable alternative to the **Hayward SP0536CTOOL**, the manufacturer's installation and removal tool for **ColorLogic 160 and 320** accent lights. The tool engages the light's outer ring and twists to expand or release the internal mounting ring inside a standard wall fitting (SP0537, SP0538).

## Three Print Profiles

Profiles 1 and 2 both print the **hand tool: the end piece *and* the handle**. The handle has extension pieces (tabs) that insert into matching slots in the underside of the end piece to hold the two together. I epoxied mine, but I also ran it *without* epoxying the handle to the end piece and it held up fine — the tabs alone keep them together. So epoxy on the handle joint is optional; glue it only if you want it permanent.

Profile 3 is the grip collar, broken out on its own because you may not need it — print it only if your OEM collar didn't survive.

**Profile 1: Separated Prongs (Stronger, Recommended)**
The end piece prints with three prong slots. The three prongs print separately, lying flat on the bed so their layer lines run along their length. You epoxy the prongs into the slots. Stronger because the strong axis of each layer is now aligned with the torque, instead of fighting it across layer bonds. The handle prints separately and its tabs insert into the end piece (epoxy on that joint optional).

**Profile 2: Integrated Prongs (Simpler)**
The end piece prints as one part with the prongs as integrated features. Fewer pieces, no prong epoxy step, faster to assemble. The trade-off is the inter-layer weakness. Even Nylon CF couldn't fully overcome it in my testing. Fine for a one-time removal or a backup. If you just need to get the light out today, this is the fastest path. The handle still prints separately and its tabs insert into the end piece (epoxy on that joint optional).

**Profile 3: Grip Collar (Optional — Print Only If Needed)**
Just the grip collar, on its own. Six gear-style teeth for hand grip, a retention lip, and three tilted arced prongs that engage the outer ring slots on the light. Print this only if your OEM Hayward collar broke — the printed end piece drops into the original collar fine. Print it by itself or alongside Profile 1 or 2.

## What's Included

Long handle: separate part, epoxied to the underside of the end piece. Tab system aligns it; epoxy holds it.
End piece: two versions, one per profile (slotted vs. integrated).
Individual prong: three needed for Profile 1.
Grip collar: one piece. Skip printing it if your OEM collar survived; the 3D-printed end piece fits inside the original collar fine.

## Key Features

Designed for FDM strength. Profile 1 puts the prongs' layer lines along the load direction, where FDM is strong, instead of perpendicular, where it delaminates.
Interlocking handle joint: three tab-and-slot pairs align the handle to the end piece before you epoxy.
Concave dish on the end piece cradles the convex face of the light fixture.
Narrowed neck on the handle gives you something ergonomic to grip and twist.
Six-tooth grip collar: gear-style cutouts for hand grip, with a retention lip and three tilted arced prongs to engage the outer ring slots on the light.
OEM-compatible end piece fits inside the manufacturer-supplied collar if you only broke the handle.

## Print Tips

**Filament:** Print in something tough. My log:

Attempt 1: Integrated prongs in ASA. Prongs snapped almost immediately.
Attempt 2: Integrated prongs in **Fiberon PA612-CF** (Nylon CF). Stronger, but still broke a prong under twist torque.
Attempt 3: Separated prongs in **Fiberon PA612-CF** + epoxy. Held up to the full install/removal torque.

PLA is going to disappoint you. PETG or ABS *might* survive Profile 1. PA-CF or PA6-CF is the safer bet for either profile. All my prints were on a **Bambu Lab P1S**.

**Orientation:** The included files are already oriented for the right layer direction. The separated prongs print flat on the bed (longitudinal layer lines), and the slotted end piece prints with the dish facing up.

**Epoxy:** Two-part epoxy is fine (5-minute or slow-cure both work). Squeeze-out is normal. Wipe or sand it after cure.

## Assembly

**Profile 1 (Separated Prongs):**
1. Print the end piece (with prong slots), three prongs, and handle. Print the grip collar too (Profile 3) only if you need it.
2. Epoxy the prongs into the end piece slots. Cure overnight.
3. Insert the handle's tabs into the slots on the underside of the end piece. Epoxy here is optional — mine ran fine unglued. If gluing, cure overnight.
4. Light sand any squeeze-out.
5. Drop the end piece into the grip collar (printed or OEM). Go remove your light.

**Profile 2 (Integrated Prongs):**
1. Print the end piece and handle. Print the grip collar too (Profile 3) only if you need it.
2. Insert the handle's tabs into the slots on the underside of the end piece. Epoxy here is optional — mine ran fine unglued. If gluing, cure overnight.
3. Drop the end piece into the grip collar (printed or OEM). Go remove your light.

**Profile 3 (Grip Collar):**
1. Print the grip collar. Drop your end piece in and go.

## Compatibility

Lights: Hayward ColorLogic 160, ColorLogic 320
Wall fittings: Hayward SP0537, SP0538 (1.5" female pipe thread)
Replaces: Hayward SP0536CTOOL

## Notes

The grip collar has its own set of prongs and could probably benefit from the same separated-prong treatment, but mine didn't break, so I haven't designed that variant yet. Eventually, maybe.

Pool equipment involves water-tight seals and electrical components. Verify fit before relying on this for anything permanent, and use at your own risk. If a prong shears mid-twist you'll know which profile you should have picked.

## Source & Documentation

OpenSCAD source, photos, and full documentation: [github.com/billism1/3d-print-hayward-accent-light-installation-tool](https://github.com/billism1/3d-print-hayward-accent-light-installation-tool)
