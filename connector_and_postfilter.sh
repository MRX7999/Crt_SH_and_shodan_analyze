echo "version 2"
echo "creater @sig671"
read -p "input domain for analyze: " domain 
echo "Set: " $domain
read -p "Your shodan api key: " SHODAN_API_KEY
$SHODAN_API_KEY 
#read -p "input name of test folder: " $domain.new
echo "Set: " $domain.new
echo "Your current user: " && whoami=($(whoami)) 
echo $whoami 
cd ~/Desktop && mkdir $domain.new && cd $domain.new && wget -O /home/$whoami/Desktop/$domain.new/$domain.new.json https://crt.sh/?q=$domain&output=json && curl -s  "https://crt.sh/?q=$domain&output=json" | jq | grep serial_number > /home/$whoami/Desktop/$domain.new/$domain.new.serial.txt
##HZ 

sleep 20
while read str 
do
#CRT.ID
  echo $str  |  gawk -v RS='</A' 'RT{gsub(/.*<A[^>]*>/,"");print;exit}' | grep -v [A-Za-z] >> /home/$whoami/Desktop/$domain.new/$domain.new.filtred.txt
done < /home/$whoami/Desktop/$domain.new/$domain.new.json 
awk '!seen[$0]++' /home/$whoami/Desktop/$domain.new/$domain.new.filtred.txt > /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.filtred.txt && awk '!seen[$0]++' /home/$whoami/Desktop/$domain.new/$domain.new.serial.txt > /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.serial.txt
cat /home/$whoami/Desktop/$domain.new/$domain.new.filtred.txt >> /home/$whoami/Desktop/$domain.new/$domain.new.crt.id.log  
sleep 5
i=$(cat /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.filtred.txt | grep -c [0-9]) 
echo "cert found: " $i
#perl -l -0777 -ne 'print $1 if /<a.*?>\s*([A-Z0-9]{64,64}?)\s*<\/a/si'
#cd ~/Desktop && mkdir $domain.new.serial && cd $domain.new.serial && curl -s "https://crt.sh/?q=$domain&output=json" | jq | grep serial_number > $domain.new.serial.txt
echo "dont forget fitration this: " $(cat /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.serial.txt | grep -c serial_number)

cat /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.filtred.txt | while read y 
do 
echo "Cert:  $y"
curl -s "https://crt.sh/?q=$y" | perl -l -0777 -ne 'print $1 if /<TD.*?>\s*([A-Z0-9]{40,40}?)\s*<\/TD/si' >> /home/$whoami/Desktop/$domain.new/$domain.sha1.txt && curl -s "https://crt.sh/?q=$y" | perl -l -0777 -ne 'print $1 if /<a.*?>\s*([A-Z0-9]{64,64}?)\s*<\/a/si' >> /home/$whoami/Desktop/$domain.new/$domain.sha256.txt
sleep 1
done < /home/$whoami/Desktop/$domain.new/cleaned.$domain.new.filtred.txt

awk '!seen[$0]++' /home/$whoami/Desktop/$domain.new/$domain.sha1.txt >> /home/$whoami/Desktop/$domain.new/$domain.cleaned.sha1.txt
ls -l /home/$whoami/Desktop/$domain.new/
cd /home/$whoami/Desktop/$domain.new/ && mkdir sha1postfilter serialpostofilter && ls && mv /home/$whoami/Desktop/$domain.new/$domain.cleaned.sha1.txt /home/$whoami/Desktop/$domain.new/sha1postfilter/$domain.cleaned.sha1.txt && mv /home/$whoami/Desktop/$domain.new/$domain.cleaned.serial.txt  /home/$whoami/Desktop/$domain.new/serialpostofilter/$domain.cleaned.serial.txt
#shodan_query()
cat /home/$whoami/Desktop/$domain.new/sha1postfilter/$domain.cleaned.sha1.txt | while read y 
do
#PIZDEC KOSTIL
echo "sha1:  $y" && "" >> /home/$whoami/Desktop/$domain.new/sha1postfilter/$y.txt
curl -X GET "https://api.shodan.io/shodan/host/search?key=$SHODAN_API_KEY&query=ssl.cert.fingerprint:$y" >> /home/$whoami/Desktop/$domain.new/sha1postfilter/$y.txt
sleep 1.5
done < /home/$whoami/Desktop/$domain.new/sha1postfilter/$domain.cleaned.sha1.txt

cat /home/$whoami/Desktop/$domain.new/serialpostofilter/$domain.cleaned.serial.txt | while read w
do
#PIZDEC KOSTIL
echo "serial:  $w" && "" >> /home/$whoami/Desktop/$domain.new/serialpostofilter/$w.txt
curl -X GET "https://api.shodan.io/shodan/host/search?key=$SHODAN_API_KEY&query=ssl.cert.serial:$w" >> /home/$whoami/Desktop/$domain.new/serialpostofilter/$w.txt
sleep 1.5
done < /home/$whoami/Desktop/$domain.new/serialpostofilter/$domain.cleaned.serial.txt
cd ~/Desktop/$domain.new/serialpostofilter && mkdir dedit  && cp $(find . -type f -size +4k) dedit/ & ls -l dedit
cd ~/Desktop/$domain.new/serialpostofilter && cd dedit && rm cleaned.serial.testing.txt && rm $(ls | grep filtred) 
echo "files: " $(ls ~/Desktop/$domain.new/serialpostofilter/dedit)
cd ~/Desktop/$domain.new/sha1postfilter && mkdir dedit  && cp $(find . -type f -size +4k) dedit/ & ls -l dedit
cd ~/Desktop/$domain.new/sha1postfilter && cd dedit && rm cleaned.serial.testing.txt && rm $(ls | grep filtred) 
echo "files: " $(ls ~/Desktop/$domain.new/sha1postfilter/dedit)
