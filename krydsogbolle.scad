board_w = 180;
board_h = 10;
board_thick = 5;
board_round_r = 8;

piece_r = [for (i = [0:2]) 10+7.5*i];
piece_h = [for (i = piece_r) 2.25*i];
piece_thick = 2;
rille_thick = 1.5 * piece_thick;

space_w = board_w/3;

draft = false;
test1_cutout = false;
test2_cutout = false;

$fs = (draft ? 0.8 : 0.2);
$fa = (draft ? 10 : 4);

module board() {
  difference() {
    union() {
      translate([0, 0, .5*board_h]) {
        cube([board_w - 1.99*board_round_r, board_w - 0*board_round_r, board_h], center=true);
        cube([board_w - 0*board_round_r, board_w - 1.99*board_round_r, board_h], center=true);
      }
      for (i = [-1:2:1]) {
        for (j = [-1:2:1]) {
          translate([i*.5*(board_w-2*board_round_r), j*.5*(board_w-2*board_round_r), 0]) {
            cylinder(h=board_h, r=board_round_r, center=false);
          }
        }
      }
    }

    for (i = [-1 : 1]) {
      for (j = [-1 : 1]) {
        translate([i*space_w, j*space_w, board_thick]) {
          for (k = [0:2]) {
            difference() {
              cylinder(h=1e3, r=piece_r[k] + 0.5*(rille_thick-piece_thick), center=false);
              cylinder(h=1e3, r=piece_r[k] - piece_thick - 0.5*(rille_thick-piece_thick), center=true);
            }
          }
        }
      }
    }
  }
}


module piece(size) {
  difference() {
    cylinder(r = piece_r[size], h = piece_h[size], center=false);
    translate([0, 0, -piece_thick])
      cylinder(r = piece_r[size] - piece_thick, h = piece_h[size], center=false);
  }
}


module krydsogbolle() {
  board();
}


if (test1_cutout) {
  intersection() {
    krydsogbolle();
    translate([-board_w/3, -board_w/3, 0]) {
      cube([board_w/2.95, board_w/2.95, 100*board_h], center=true);
    }
  }

} else if (test2_cutout) {

  piece(2);

} else {

  krydsogbolle();
  for (i = [0:2]) {
    if (true) {
      translate([.7*board_w, board_w/3*(i-1), board_thick]) {
        piece(i);
      }
    } else {
      translate([board_w/3*(i-1), board_w/3*(i-1), board_thick]) {
        piece(i);
      }
    }
  }

}
