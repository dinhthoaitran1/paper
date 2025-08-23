# https://opensource.org/license/mit
#
# Copyright 2025 Dinh Thoai Tran
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or 
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 

if ($#ARGV != 2) {
  print "\n=[SYNTAX]=> perl paper.pl <data_file> <template_file> <result_file>\n\n";
  exit();
}

open my $fh, '<', $ARGV[0] or die "\n=[E]=> Cannot open data file: $!\n";

my %data;
my @sections;
my @section_keys;
my @section_sizes;

while (my $line = <$fh>) {
  my $idx = index($line, ":");
  my $key = "";
  if ($idx < 0) {
    last;
  }
  $key = substr($line, 0, $idx);
  $key =~ s/^\s+|\s+$//g;
  my $val = substr($line, $idx + 1);
  $val =~ s/^\s+|\s+$//g;
  $val =~ s/\\n/\n/g;
  $data{$key} = $val;
  $idx2 = index($key, "_tpl");
  if ($idx2 >= 0) {
    $key4 = substr($key, 0, $idx2);
    $key4 =~ s/^\s+|\s+$//g;
    $idx3 = index($val, "|");
    $sz = substr($val, 0, $idx3);
    $key3 = substr($val, $idx3+1);
    $key3 =~ s/^\s+|\s+$//g;
    push(@sections, $key3);
    push(@section_sizes, $sz);
    push(@section_keys, $key4);
  }
}

close $fh or die "\n=[E]=> Cannot close data file: $!\n";

$tpl_file = $ARGV[1];

my $html = "";

open my $fh2, '<', $tpl_file or die "\n=[E]=> Cannot open template file: $!\n";

while (my $line = <$fh2>) {
  $html .= $line;
}

close $fh2 or die "\n=[E]=> Cannot close template file: $!\n";

while (my ($key, $val) = each %data) {
  $idx = index($key, "_no_");
  if ($idx < 0) {
    my $fnd = "__" . $key . "__";
    my $key10 = $key . "_repchar";
    if (exists $data{$key10}) {
      my $chars = $data{$key10};
      $chars =~ s/^\s+|\s+$//g;
      @words = split(",", $chars);
      my $k_sz = $#words + 1;
      for (my $k = 0; $k < $k_sz; $k++) {
        $k2 = $words[$k];
        $k2a = $k2 . "";
        $k2a =~ s/\+/\\+/g;
        $k3 = $key . "_rc_" . $k2;
        $v2 = $data{$k3};
        $val =~ s/$k2a/$v2/g;
      }
    }
    $html =~ s/$fnd/$val/g;
  }
}

my $sec_sz = $#sections + 1;

for (my $i = 0; $i < $sec_sz; $i++) {
  my $var_key = $section_keys[$i];
  my $tpl_key = $sections[$i];
  my $var_sz = $section_sizes[$i];
  my $tpl_key2 = $tpl_key;
  $tpl_key2 =~ s/-tpl//g;
  my $start_key = '<div class="' . $tpl_key . '">';
  my $start_idx = index($html, $start_key);
  if ($start_idx >= 0) {
    my $end_key = '</div><!-- "' . $tpl_key . '" -->';
    my $end_idx = index($html, $end_key, $start_idx + length($start_key));
    if ($end_idx >= 0) {
      my $html_left = substr($html, 0, $start_idx);
      my $html_right = substr($html, $end_idx + length($end_key));
      my $html_inner = substr($html, $start_idx + length($start_key), $end_idx - $start_idx - length($start_key));
      my $html_center = "";
      for (my $j = 0; $j < $var_sz; $j++) {
        $no = $j + 1;
        $suffix = "_no_" . $no;
        my $inner = $html_inner . "";
        while (my ($key, $val) = each %data) {
          $idx = index($key, $var_key);
          if ($idx == 0) {
            $idx2 = index($key, $suffix);
            if ($idx2 >= 0) {
              my $key5 = substr($key, 0, $idx2) . "_repchar";
              if (exists $data{$key5}) {
                my $chars = $data{$key5};
                $chars =~ s/^\s+|\s+$//g;
                my @words = split(",", $chars);
                my $k_sz = $#words + 1;
                for (my $k = 0; $k < $k_sz; $k++) {
                  $k2 = $words[$k];
                  $k2a = $k2 . "";
                  $k2a =~ s/\+/\\+/g;
                  $k3 = substr($key, 0, $idx2) . "_rc_" . $k2;
                  $v2 = $data{$k3};
                  $val =~ s/$k2a/$v2/g;
                }
              }
              $tpl_key2 = "__" . substr($key, 0, $idx2) . "__";
              $inner =~ s/$tpl_key2/$val/g;
            }
          }
        }
        $html_center = $html_center . "\n" . $inner;
      }
      $html = $html_left . $html_center . $html_right;
    }
  }
}

$result_file = $ARGV[2];

open my $fh3, '>', $result_file or die "\n=[E]=> Cannot write to result file: $!\n";

print $fh3 $html;

close $fh3 or die "\n=[E]=> Cannot close result file: $!\n";

print "Your paper is built successfully!";

