set terminal postscript enhanced color
set output "| pstopdf -i -o graph.pdf"

# set term png
# set output "graph.png"
set xlabel "Size"
set ylabel "Time"
plot 'times_serial.dat' title 'Serial' with lines, \
    'times_sse.dat' title 'SSE' with lines, \
    'times_serial_with_sse.dat' title 'Serial + -msse' with lines, \
    'times_sse_with_sse.dat' title 'SSE + -msse' with lines
