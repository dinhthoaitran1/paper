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

use Cwd;
use Cwd 'abs_path';

if ($#ARGV != 0) {
  print "\n=[SYNTAX]=> perl merge_file.pl <file>\n\n";
  exit();
}

my $tag_file = abs_path($ARGV[0]);

my $part = 1;

while ($part > 0) {
  my $part_file = $tag_file . "." . $part;
  -e $part_file or last;
  $part++;
}

open my $fh, '>', $tag_file or die "\n=[E]=> Cannot open file: $!\n";
binmode $fh;

my $buffer_size = 1024 * 1024 * 2;
my $buffer = ''; 
my $no = 1;
while ($no <= $part) {
  my $part_file = $tag_file . "." . $no;
  my $read_size = $buffer_size;
  open my $fh2, '<', $part_file or last;
  binmode $fh2;
  while ($read_size == $buffer_size) {
    $read_size = read $fh2, $buffer, $buffer_size or last;
    print $fh $buffer;
  }
  close $fh2 or die "\n=[E]=> Cannot close file: $!\n";
  $no++;
}

close $fh or die "\n=[E]=> Cannot close file: $!\n";

$no--;

print $no . " part files are merged.";
 
