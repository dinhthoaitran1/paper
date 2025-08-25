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
# Ref URL: https://perldoc.perl.org/Encode
#

use Encode qw(decode encode);

if ($#ARGV != 1) {
  print "\n=[SYNTAX]=> perl utf_8_to_shift_jis.pl <data_file> <result_file>\n\n";
  exit();
}

open my $fh, '<', $ARGV[0] or die "\n=[E]=> Cannot open data file: $!\n";

my $text = '';

while (my $line = <$fh>) {
  $text = $text . $line;
}

close $fh or die "\n=[E]=> Cannot close data file: $!\n";

$text_utf_8 = decode("UTF-8", $text);
$text_shift_jis = encode("shiftjis", $text_utf_8);

$result_file = $ARGV[1];

open my $fh3, '>', $result_file or die "\n=[E]=> Cannot write to result file: $!\n";

print $fh3 $text_shift_jis;

close $fh3 or die "\n=[E]=> Cannot close result file: $!\n";

print "Your data file is converted successfully!";

