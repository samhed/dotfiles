function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'

  # Onedark colors
  set -l black       0c0e15
  set -l white       d0d0ef
  set -l bg0         1a212e
  set -l bg1         21283b
  set -l bg2         283347
  set -l bg3         2a324a
  set -l bg_d        141b24
  set -l bg_blue     54b0fd
  set -l bg_yellow   f2cc81
  set -l fg          93a4c3
  set -l purple      c75ae8
  set -l green       8bcd5b
  set -l orange      dd9046
  set -l blue        41a7fc
  set -l yellow      efbd5d
  set -l cyan        34bfd0
  set -l red         f65866
  set -l grey        455574
  set -l light_grey  6c7d9c
  set -l dark_cyan   1b6a73
  set -l dark_red    992525
  set -l dark_yellow 8f610d
  set -l dark_purple 862aa1

  # Optionally include a base color scheme
  __bobthefish_colors default

  set -x color_initial_segment_exit     $bg1 $red --bold
  set -x color_initial_segment_private  $bg1 $bg3 --bold
  set -x color_initial_segment_su       $bg1 $green --bold
  set -x color_initial_segment_jobs     $bg1 $blue --bold

  set -x color_path                     $bg2 $fg
  set -x color_path_basename            $bg2 $fg --bold
  set -x color_path_nowrite             $bg3 $orange
  set -x color_path_nowrite_basename    $bg3 $orange --bold

  set -x color_repo                     $green $black
  set -x color_repo_work_tree           $bg3 $fg --bold
  set -x color_repo_dirty               $dark_yellow $white
  set -x color_repo_staged              $dark_cyan $white

  set -x color_vi_mode_default          $grey $black --bold
  set -x color_vi_mode_insert           $green $black --bold
  set -x color_vi_mode_visual           $purple $black --bold

  set -x color_username                 $bg0 $green --bold
  set -x color_hostname                 $bg0 $blue
end
