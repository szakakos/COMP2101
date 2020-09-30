echo "setuid files:"
echo "============="
find / -type f -executable -perm -4000 -ls 2>/dev/null | sort -k 5
echo ""

echo "biggest setuid files:"
echo "============="
find / -type f -executable -perm -4000 -ls 2>/dev/null | sort -h -k7 | awk 'FNR <= 10 {print $5, $3, $9, $7}'
echo ""
