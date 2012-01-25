#!sh
pandoc -sS Matthew-Hickford-CV.markdown  -o Matthew-Hickford-CV.html
markdown2pdf Matthew-Hickford-CV.markdown
cp Matthew-Hickford-CV.markdown Matthew-Hickford-CV.txt
chmod 0222 Matthew-Hickford-CV.txt
attrib +R Matthew-Hickford-CV.txt
pandoc -sS index.markdown -o index.html
