include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 96;

// corner definition
//
cut = 1.5;
k=.7;
rounding = 2;

// snugness of the fit
delta=.15;

length = 80;
width = 40;
top_height = 10;
bottom_height = 19;
thickness = 3.2;
overlap = 3;

tracker_length = 63.64;
tracker_width = 28;
tracker_height = 8.62;
wifi_antenna_height = 1.5;

screen_width = 12;
screen_length = 24;

gnss_width = 20;
gnss_height = 0.75;

usb_hang = 2.2;
usb_width = 9;
usb_height = 3.5;
usb_z = 2;
battery_length = 50;
battery_width = 34;
battery_height = 10;

antenna_diameter = 6.5;

module top_shell() {
    union() {
        difference() {
            cuboid(size=[width, length, top_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
            up(thickness) cuboid([width-thickness,length-thickness,top_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
            up(top_height - overlap) cuboid([width-thickness*0.5,length-thickness*0.5,top_height], anchor=BOTTOM, rounding=rounding, edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
        }

        // Use glue instead of locks!
        // lock size
        //lock = 1;

        //up(top_height - overlap * 0.25) {
        //    for (i = [-1:1]) {
        //        for (j = [-1:2:1]) {
        //            left(j * (0.5 * width - 0.25 * thickness))
        //            fwd(i * length * 0.25)
        //                prismoid(size1=[lock,5], size2=[0, 5], h=overlap * 0.5, anchor=TOP);
        //        }
        //    }

        //    fwd(0.5 * length - 0.25 * thickness) {
        //        left(0.25 * width) prismoid(size1=[5,lock], size2=[5, 0], h=overlap * 0.5, anchor=TOP);
        //        right(0.25 * width) prismoid(size1=[5,lock], size2=[5, 0], h=overlap * 0.5, anchor=TOP);
        //    }
        //    back(0.5 * length - 0.25 * thickness) {
        //        left(0.25 * width) prismoid(size1=[5,lock], size2=[5, 0], h=overlap * 0.5, anchor=TOP);
        //        right(0.25 * width) prismoid(size1=[5,lock], size2=[5, 0], h=overlap * 0.5, anchor=TOP);
        //    }
        //}
    }
}

module usbc() {
    fwd(length/2) cuboid($fn=20,[usb_width, 20, usb_height], rounding=1.4, anchor=BOTTOM);
}

tracker_position_y = length * 0.5 - thickness;

module case() {
    difference() {
        union() {
            difference() {
                top_shell();

                // Usb-C
                up(thickness + usb_z) usbc();

                // Screen window
                fwd(tracker_position_y - 11 + thickness) down(0.01) prismoid(size1=[screen_width + 3*thickness, screen_length + 2*thickness], size2=[screen_width, screen_length], h=thickness+0.02, anchor=BOTTOM+FRONT);

                // WiFi antenna hole
                up(thickness) fwd(tracker_position_y - 21.0) right(tracker_width * 0.5 - 3) cylinder(h=2*wifi_antenna_height, r=2, anchor=CENTER);
            }

            // Buttons
            fwd(tracker_position_y - 3) {
                left(8) up(thickness) cylinder(h=1, r1=5, r2=2, anchor=BOTTOM);
                right(8) up(thickness) cylinder(h=1, r1=5, r2=2, anchor=BOTTOM);
            }

            // Screen seal
            fwd(tracker_position_y - 10) up(thickness) rect_tube(size=[screen_width + 2, screen_length + 2], wall=1, h=1, anchor=BOTTOM+FRONT);

            // PCB stands
            fwd(tracker_position_y - tracker_length * 0.2) {
                left(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+LEFT);
                right(tracker_width * 0.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+RIGHT);
            }
            fwd(tracker_position_y - tracker_length * 0.77) {
                left(tracker_width * 0.5 - 1.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+LEFT);
                right(tracker_width * 0.5 - 1.5) cuboid(size=[2,10,4 + usb_height], anchor=BOTTOM+RIGHT);
            }

            // back stands
            fwd(tracker_position_y - tracker_length) up(rounding) {
                left(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
                right(10) cuboid(size=[5,2,5 + usb_height - rounding], anchor=BOTTOM+FRONT);
            }

            // front stand
            fwd(tracker_position_y - 8) {
                up(thickness) cuboid(size=[5,2,4 + usb_height - thickness], anchor=BOTTOM+FRONT);
            }
        }

        // LED windows
        fwd(tracker_position_y - 8) {
            left(6) cylinder(h=5*thickness, r=1.72, anchor=CENTER);
            right(6) cylinder(h=5*thickness, r=1.72, anchor=CENTER);
        }

        // Button holes
        down(0.5) fwd(tracker_position_y - 3) {
            left(8) {
                cylinder(r1=4, r2=1, h=3, anchor=BOTTOM);
                cylinder(r=1.5, h=10, anchor=BOTTOM);
            }
            right(8) {
                cylinder(r1=4, r2=1, h=3, anchor=BOTTOM);
                cylinder(r=1.5, h=10, anchor=BOTTOM);
            }
        }
    }
}

module button() {
    cylinder(h=1.5, r=2, anchor=BOTTOM);
    up(1.5) cylinder(h=4.5, r=1.2, anchor=BOTTOM);
}

module lid() {
    difference() {
        union() {
            difference() {
                cuboid(size=[width, length, bottom_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
                up(thickness) cuboid([width-thickness,length-thickness,bottom_height], anchor=BOTTOM, rounding=rounding, edges=[BOTTOM, FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]);
                up(top_height + bottom_height - overlap) yrot(180) {
                    top_shell();
                    scale([1.01, 1.01, 1]) top_shell();
                }

                // A hole for USB
                up(bottom_height - (top_height - thickness - usb_height - usb_z)) usbc();

                // A hole for the back stands
                back(tracker_length * 0.5) up(bottom_height - (overlap - 1)) {
                    left(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                    right(10) cuboid(size=[5,10,10], anchor=BOTTOM);
                }
            }

            // Battery support
            back(battery_length - length * 0.5 + 10) up(rounding) {
                left(width * 0.5) cuboid(size=[9,3,1 + bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+LEFT);
                right(width * 0.5) cuboid(size=[9,3,1 + bottom_height - thickness - overlap], anchor=BOTTOM+FRONT+RIGHT);
            }

            fwd(length * 0.5 - 10) up(rounding) {
                left(width * 0.5) cuboid(size=[9,3,1 + bottom_height - thickness - overlap], anchor=BOTTOM+BACK+LEFT);
                right(width * 0.5) cuboid(size=[9,3,1 + bottom_height - thickness - overlap], anchor=BOTTOM+BACK+RIGHT);
            }

            // Antenna support
            bulge_thickness = 1;
            back(length*0.5 - bulge_thickness) hull() {
                up(bottom_height/2) xrot(90) cylinder(h=bulge_thickness, r=antenna_diameter/2 + 2);
                up(thickness) cuboid(size=[antenna_diameter + 4, bulge_thickness, 3], anchor=BOTTOM+BACK);
            }

            // Strap support
            up(0.5*rounding) back(0.5 * length - 0.5*rounding) {
                right(0.5 * width - 0.5*rounding)
                cuboid([12,12,10], rounding=rounding, anchor=BACK+BOTTOM+RIGHT);
                left(0.5 * width - 0.5*rounding)
                cuboid([12,12,10], rounding=rounding, anchor=BACK+BOTTOM+LEFT);
            }

        }

        // Antenna
        up(bottom_height/2) back(length*0.5 + 10) xrot(90) cylinder(h=20, r=antenna_diameter/2);

        // Strap holes
        up(7) back(0.5 * length) {
            right(0.5 * width)
            rotate_extrude(convexity = 10)
                translate([-8, 0, 0])
                    circle(r = 2.5);

            left(0.5 * width)
            rotate_extrude(convexity = 10)
                translate([8, 0, 0])
                    circle(r = 2.5);
        }
    }
}

case();

right(50) lid();
left(30) button();
left(40) button();
