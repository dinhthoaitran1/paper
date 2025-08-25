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
use File::Basename;

if ($#ARGV != 1) {
  print "\n=[SYNTAX]=> perl split_file.pl <part_size_kb> <file>\n\n";
  exit();
}

my $part_size = $ARGV[0];
$part_size = 1024 * $part_size;
my $src_file = abs_path($ARGV[1]);
my ($name, $path, $suffix) = fileparse($src_file, @suffixlist);

open my $fh, '<', $src_file or die "\n=[E]=> Cannot open file: $!\n";
binmode $fh;

my $read_size = $part_size;
my $buffer = '';
my $part = 1;

# Ref: https://www.perlmonks.org/?node_id=937182

while ($read_size == $part_size) {
  $read_size = read $fh, $buffer, $part_size or last;
  $tag_file = $path . "/" . $name . "." . $part;
  open my $fh2, '>', $tag_file or die "\n=[E]=> Can not open file: $!\n";
  binmode $fh2;
  print $fh2 $buffer;
  close $fh2 or die "\n=[E]=> Cannot close file: $!\n";
  $part++;
}

$part--;

close $fh or die "\n=[E]=> Cannot close file: $!\n";

print "File is splitted into " . $part . " parts."; 

