

#First run

#Import translated file

#runtype="English"

#Second run

#Import native file

#runtype="native"


#file=filenative
#data = read.csv(file, sep=";", quote="", encoding = "UTF-8")

#runtype="native"
#if (runtype=="native") Language=foreignlanguage

#for chinese, minfreq needs to be 1 not 2
#minfreq=1



#data = read.csv(file, sep=";", quote="", encoding = "UTF-8")
#data = read.csv(file, sep=";", fileEncoding = "UTF-8")






#data = read.csv(file, sep=";", quote="", encoding = "UTF-8")
#Need to add this type of indicator, Must run english first
#runtype="English"
#runtype="native"
#if (runtype=="English") Language="english"
#if (runtype=="native") Language=foreignlanguage
#danish, dutch, english, finnish, french, german, hungarian, italian, norwegian, portuguese, russian, spanish and swedish.



#path=paste0(getwd(),"/")
#data = read.csv(file, sep=";", quote="", encoding = "UTF-8")
#data = read.csv(file, sep=";", quote="")
#data = read.csv(file, sep=";")

library(translate)
library(syuzhet)
library(tm)
library(wordcloud)
library(XLConnect)

minfreq=2

if (sum(as.numeric(rownames(data)))!=length(as.numeric(rownames(data)))*(length(as.numeric(rownames(data)))+1)/2 & is.na(data[1,ncol(data)])) {
colnum=ncol(data)  

data1=data.frame(data[,1:(colnum-1)])

ids=as.numeric(rownames(data1))
colnum=ncol(data1)

} else {
  colnum=ncol(data)
  data1=data.frame(data[,2:(colnum)])
  colnum=ncol(data1)
  #for (i in 1:nrow(data1)) rownames(data1)[i]=data[i,1]
  ids=as.numeric(data[,1])
  
}
#ids=as.numeric(rownames(data1))
for (j in 1:colnum) {
#data2=(unlist(data1[,j]))
data2=(data1[,j])

#set.key('AIzaSyCOYjQRF01MkW3oUT8SxyHWJ4EaiGIHO10')
#for (k in 1:nrow(data2)) {
#data2[k,1]=translate(unlist(data2[k,1]), source=NULL, target='en', key = get.key())[[1]][1]
#}
#remove people who say there is nothing
#if (runtype!="native") {


data2 <- gsub(","," ",tolower(data2))
data2 <- gsub("'","",tolower(data2))

data2 <- gsub('"','',tolower(data2))
data2 <- gsub("\"","",tolower(data2))

data2 <- gsub("&#38;","",tolower(data2))
data2 <- gsub("&#39;","",tolower(data2))
data2 <- gsub("&#38 ","",tolower(data2))
data2 <- gsub("&#39 ","",tolower(data2))
data2 <- gsub("&quot","",tolower(data2))
data2 <- gsub("â€™ ","",tolower(data2))
data2 <- gsub("â€™","",tolower(data2))


data2[is.na(data2)]=""
data2[tolower(data2)=="no"]=""
data2[tolower(data2)=="non"]=""
data2[tolower(data2)=="no no"]=""
data2[tolower(data2)=="nothing comes to mind"]=""
data2[tolower(data2)==" no"]=""
data2[tolower(data2)=="no "]=""
data2[tolower(data2)==" no "]=""
data2[tolower(data2)=="No"]=""
data2[tolower(data2)=="no."]=""
data2[tolower(data2)=="nothing"]=""
data2[tolower(data2)=="n/a"]=""
data2[tolower(data2)=="none"]=""
data2[tolower(data2)=="N/A"]=""
data2[tolower(data2)=="NA"]=""
data2[tolower(data2)==" NA"]=""
data2[tolower(data2)=="NA "]=""
data2[tolower(data2)=="nope"]=""

if (exists("runtype")) {
  if (runtype=="English") {
    data2 <- gsub("[^a-zA-Z0-9?! _]","",tolower(data2))
  }
}

data1[,j]=data2


# Start of recoder results

if (file.exists(paste0(path,"Custom3.R"))) {
source(paste0(path,"Custom3.R")) 
print("Importing Custom code")  
}


# end of recoder results






data2 <- gsub("get myself","noneed",tolower(data2))
data2 <- gsub("not a product i","noneed",tolower(data2))
data2 <- gsub("melt too fast","noneed",tolower(data2))
data2 <- gsub("i never order","noneed",tolower(data2))
data2 <- gsub("dont really","noneed",tolower(data2))
data2 <- gsub("do not really","noneed",tolower(data2))
data2 <- gsub("how would they","noneed",tolower(data2))
data2 <- gsub("not going to pay","noneed",tolower(data2))
data2 <- gsub("not delivered hot","noneed",tolower(data2))
data2 <- gsub("would be concerned for price","noneed",tolower(data2))
data2 <- gsub("would be concerned for","noneed",tolower(data2))
data2 <- gsub("would be concerned","noneed",tolower(data2))
data2 <- gsub("like using a delivery service for","noneed",tolower(data2))
data2 <- gsub("i wouldnt pay","noneed",tolower(data2))
data2 <- gsub("i would not pay","noneed",tolower(data2))
data2 <- gsub("no good","noneed",tolower(data2))
data2 <- gsub("i make my own","noneed",tolower(data2))
data2 <- gsub("i dont eat/drink","noneed",tolower(data2))
data2 <- gsub("would not even be possible","noneed",tolower(data2))
data2 <- gsub("i dont eat","noneed",tolower(data2))
data2 <- gsub("i do not eat","noneed",tolower(data2))
data2 <- gsub("not confident","noneed",tolower(data2))
data2 <- gsub("not worth it","noneed",tolower(data2))
data2 <- gsub("not sure this is a great idea","noneed",tolower(data2))
data2 <- gsub("do not use","noneed",tolower(data2))
data2 <- gsub("dont use","noneed",tolower(data2))
data2 <- gsub("not a starbucks fan","noneed",tolower(data2))
data2 <- gsub("not a uber fan","noneed",tolower(data2))
data2 <- gsub("i hadnt thought of","noneed",tolower(data2))
data2 <- gsub("i had not thought of","noneed",tolower(data2))
data2 <- gsub("never really liked","noneed",tolower(data2))
data2 <- gsub("i never really liked","noneed",tolower(data2))
data2 <- gsub("i like to order by myself","noneed",tolower(data2))
data2 <- gsub("will not be available","noneed",tolower(data2))
data2 <- gsub("wont be available","noneed",tolower(data2))
data2 <- gsub("wont be fresh","noneed",tolower(data2))
data2 <- gsub("will not be fresh","noneed",tolower(data2))
data2 <- gsub("i never use","noneed",tolower(data2))
data2 <- gsub("never use","noneed",tolower(data2))
data2 <- gsub("not at all interested","noneed",tolower(data2))
data2 <- gsub("wont be hot enough","noneed",tolower(data2))
data2 <- gsub("will not be hot enough","noneed",tolower(data2))
data2 <- gsub("will not be hot","noneed",tolower(data2))
data2 <- gsub("wont be hot","noneed",tolower(data2))
data2 <- gsub("i prefer to","noneed",tolower(data2))
data2 <- gsub("i would prefer to","noneed",tolower(data2))
data2 <- gsub("i would prefer my","noneed",tolower(data2))
data2 <- gsub("just like all the other","noneed",tolower(data2))
data2 <- gsub("just like the other","noneed",tolower(data2))
data2 <- gsub("i would not consider","noneed",tolower(data2))
data2 <- gsub("i wouldnt consider","noneed",tolower(data2))
data2 <- gsub("not in the position","noneed",tolower(data2))
data2 <- gsub("i can always fine","noneed",tolower(data2))
data2 <- gsub("cant imagine","noneed",tolower(data2))
data2 <- gsub("ddnt trust","noneed",tolower(data2))
data2 <- gsub("can't imagine","noneed",tolower(data2))
data2 <- gsub("can not imagine","noneed",tolower(data2))
data2 <- gsub("will never use","noneed",tolower(data2))
data2 <- gsub("never use","noneed",tolower(data2))
data2 <- gsub("i would never use","noneed",tolower(data2))
data2 <- gsub("i would never eat/drink","noneed",tolower(data2))
data2 <- gsub("i would never eat","noneed",tolower(data2))
data2 <- gsub("i would never","noneed",tolower(data2))
data2 <- gsub("i would not order","noneed",tolower(data2))
data2 <- gsub("i wouldnt order","noneed",tolower(data2))
data2 <- gsub("not needed","noneed",tolower(data2))
data2 <- gsub("really not interested","reallynotinterested",tolower(data2))
data2 <- gsub("not bad","notbad",tolower(data2))
data2 <- gsub("not good","notgood",tolower(data2))
data2 <- gsub("would buy","wouldbuy",tolower(data2))
data2 <- gsub("not for me","notforme",tolower(data2))
data2 <- gsub("makes you","makesyou",tolower(data2))
data2 <- gsub("not expensive","notexpensive",tolower(data2))
data2 <- gsub("not sure","notsure",tolower(data2))   
data2 <- gsub("too much","toomuch",tolower(data2))
data2 <- gsub("seems ok","seemsok",tolower(data2))   
data2 <- gsub("sounds ok","soundsok",tolower(data2))
data2 <- gsub("no idea","noidea",tolower(data2))

data2 <- gsub("didnt like","didntlike",tolower(data2))
data2 <- gsub("dont like it","dontlike",tolower(data2))
data2 <- gsub("dont like","dontlike",tolower(data2))
data2 <- gsub("don't like","dontlike",tolower(data2))
data2 <- gsub("dodnt like","dontlike",tolower(data2))
data2 <- gsub("do not like","dontlike",tolower(data2))
data2 <- gsub("no thanks","nothanks",tolower(data2))
data2 <- gsub("would not like","wouldntlike",tolower(data2))
data2 <- gsub("wouldnotbeinterested","wouldntlike",tolower(data2))
data2 <- gsub("wont like","wontlike",tolower(data2))
data2 <- gsub("dodnt like","didntlike",tolower(data2))
data2 <- gsub("does not sound","doesnotsound",tolower(data2))
data2 <- gsub("does not appeal","doesnotappeal",tolower(data2))
data2 <- gsub("never try","nevertry",tolower(data2))
data2 <- gsub("no thank you","nothankyou",tolower(data2))
data2 <- gsub("groos","gross",tolower(data2))
data2 <- gsub("dont think","dontthink",tolower(data2))
data2 <- gsub("not appealing","notappealing",tolower(data2))
data2 <- gsub("doesnt sound","doesntsound",tolower(data2))
data2 <- gsub("does not sound","doesntsound",tolower(data2))
data2 <- gsub("dont go","dontgo",tolower(data2))
data2 <- gsub("dont care","dontcare",tolower(data2))
data2 <- gsub("dont not care","dontcare",tolower(data2))
data2 <- gsub("not a fan","notafan",tolower(data2))
data2 <- gsub("dont drink","dontdrink",tolower(data2))
data2 <- gsub("do not drink","dontdrink",tolower(data2))
data2 <- gsub("not interested","notinterested",tolower(data2))
data2 <- gsub("no interested","notinterested",tolower(data2))
data2 <- gsub("no interest","notinterested",tolower(data2))
data2 <- gsub("not the best","notthebest",tolower(data2))
data2 <- gsub("wouldnt drink","wouldntdrink",tolower(data2))
data2 <- gsub("not really","notreally",tolower(data2))
data2 <- gsub("would not","wouldnt",tolower(data2))
data2 <- gsub("does not","doesnt",tolower(data2))
data2 <- gsub("do not want","dontwant",tolower(data2))
data2 <- gsub("dont want","dontwant",tolower(data2))
data2 <- gsub("its not something","notsomethingiwould",tolower(data2))
data2 <- gsub("not something i would buy","notsomethingiwould",tolower(data2))
data2 <- gsub("not something i would","notsomethingiwould",tolower(data2))
data2 <- gsub("not something","notsomethingiwould",tolower(data2))
data2 <- gsub("dont shop","dontshop",tolower(data2))
data2 <- gsub("no starbucks","no starbucks",tolower(data2))
data2 <- gsub("would not try","wouldnottry",tolower(data2))
data2 <- gsub("dont sound good","dontsoundgood",tolower(data2))
data2 <- gsub("not my type of drink","notmytypeofdrink",tolower(data2))
data2 <- gsub("not my type","notmytype",tolower(data2))
data2 <- gsub("not my kind of thing","notmykindofthing ",tolower(data2))
data2 <- gsub("no use","nouse ",tolower(data2))
data2 <- gsub("do not trust","donttrust",tolower(data2))
data2 <- gsub("really dont trust","donttrust",tolower(data2))
data2 <- gsub("really do not trust","donttrust",tolower(data2))
data2 <- gsub("dont really trust","donttrust",tolower(data2))
data2 <- gsub("dont trust","donttrust",tolower(data2))
data2 <- gsub("wouldnt trust","donttrust",tolower(data2))
data2 <- gsub("would not trust","donttrust",tolower(data2))
data2 <- gsub("Would not touch","wouldnttrust",tolower(data2))
data2 <- gsub("Wouldnt touch","wouldnttrust",tolower(data2))
data2 <- gsub("Wouldnt buy","wouldntbuy",tolower(data2))
data2 <- gsub("Would not buy","wouldntbuy",tolower(data2))
data2 <- gsub("Would not purchase","wouldntbuy",tolower(data2))
data2 <- gsub("Wouldnt purchase","wouldntbuy",tolower(data2))
data2 <- gsub("not convinced","notconvinced",tolower(data2))
data2 <- gsub("i dont go","idont",tolower(data2))
data2 <- gsub("i dont do","idont",tolower(data2))
data2 <- gsub("not interested","nointerest",tolower(data2))
data2 <- gsub("no interest","nointerest",tolower(data2))
data2 <- gsub("doesnt interest","nointerest",tolower(data2))
data2 <- gsub("does not interest","nointerest",tolower(data2))
data2 <- gsub("not any interested","nointerest",tolower(data2))

data2 <- gsub("not my style","notmystyle",tolower(data2))
data2 <- gsub("not in my style","notmystyle",tolower(data2))
data2 <- gsub("not to my liking","dontlike",tolower(data2))
data2 <- gsub("not something i liking","dontlike",tolower(data2))
data2 <- gsub("not something i need","dontlike",tolower(data2))
data2 <- gsub("not something i do","dontlike",tolower(data2))
data2 <- gsub("not something i would like","dontlike",tolower(data2))
data2 <- gsub("not too sure","notsure",tolower(data2))
data2 <- gsub("not sure","notsure",tolower(data2))
data2 <- gsub("not what i like","dontlike",tolower(data2))
data2 <- gsub("dont find this exceptional","dontlike",tolower(data2))
data2 <- gsub("will cost a lot","expensive",tolower(data2))
data2 <- gsub("cost a lot","expensive",tolower(data2))
data2 <- gsub("does not seem good to me","dontlike",tolower(data2))
data2 <- gsub("not into","dontlike",tolower(data2))
data2 <- gsub("doesnt seem","dontlike",tolower(data2))
data2 <- gsub("do not care","dontlike",tolower(data2))
data2 <- gsub("do not buy","dontlike",tolower(data2))
data2 <- gsub("do not purchase","dontlike",tolower(data2))
data2 <- gsub("dont purchase","dontlike",tolower(data2))
data2 <- gsub("dont buy","dontlike",tolower(data2))
data2 <- gsub("need more information","nothing",tolower(data2))
data2 <- gsub("i have no opinion","noidea",tolower(data2))
data2 <- gsub("no opinion","noidea",tolower(data2))
data2 <- gsub("dont love","dontlike",tolower(data2))
data2 <- gsub("do not love","dontlike",tolower(data2))
data2 <- gsub("not very appealing","notappealing",tolower(data2))
data2 <- gsub("non appetizing","notappealing",tolower(data2))
data2 <- gsub("not appetizing","notappealing",tolower(data2))
data2 <- gsub("dont know","dontknow",tolower(data2))
data2 <- gsub("do not know","dontknow",tolower(data2))
data2 <- gsub("no leak","noleak",tolower(data2))
data2 <- gsub("not leak","noleak",tolower(data2))
data2 <- gsub("not too expensive","nottooexpensive",tolower(data2))
data2 <- gsub("long lasting","longlasting",tolower(data2))
data2 <- gsub("long lasting","longlasting",tolower(data2))
data2 <- gsub("less likely","lesslikely",tolower(data2))
data2 <- gsub("too glossy","tooglossy",tolower(data2))
data2 <- gsub("too glossy","tooglossy",tolower(data2))
data2 <- gsub("pain reliever","painreliever",tolower(data2))
data2 <- gsub("not old-fashioned","notoldfashioned",tolower(data2))
data2 <- gsub("not old fashioned","notoldfashioned",tolower(data2))
data2 <- gsub("old fashioned","oldfashioned",tolower(data2))
data2 <- gsub("old-fashioned","oldfashioned",tolower(data2))
data2 <- gsub("fast acting","fastacting",tolower(data2))
data2 <- gsub("not typical ad","nottypicalad",tolower(data2))
data2 <- gsub("typical ad","typicalad",tolower(data2))
data2 <- gsub("wouldnt help with pain","wouldnthelpwithpain",tolower(data2))
data2 <- gsub("would not help with pain","wouldnthelpwithpain",tolower(data2))
data2 <- gsub("does not sound any different","doesnotsoundanydifferent",tolower(data2))
data2 <- gsub("doesnt sound any different","doesnotsoundanydifferent",tolower(data2))
data2 <- gsub("no new","nonew",tolower(data2))
data2 <- gsub("nothing new","nonew",tolower(data2))
data2 <- gsub("no need","noneed",tolower(data2))
data2 <- gsub("do not need","noneed",tolower(data2))
data2 <- gsub("i dont need","noneed",tolower(data2))
data2 <- gsub("dont need","noneed",tolower(data2))
data2 <- gsub("don't need","noneed",tolower(data2))
data2 <- gsub("not too relevant","noneed",tolower(data2))
data2 <- gsub("not relevant","noneed",tolower(data2))
data2 <- gsub("no reaction","nothing",tolower(data2))
data2 <- gsub("not enough information","nothing",tolower(data2))
data2 <- gsub("not enough info","nothing",tolower(data2))
data2 <- gsub("we dont eat","wedonteat",tolower(data2))
data2 <- gsub("already exists","alreadyexists",tolower(data2))
data2 <- gsub("not new","notnew",tolower(data2))
data2 <- gsub("sounds strange","soundsstrange",tolower(data2))
data2 <- gsub("might or might not like it","mightnotlikeit",tolower(data2))
data2 <- gsub("think it is another brand","thinkanotherbrand",tolower(data2))
data2 <- gsub("would not use","wouldnotuse",tolower(data2))
data2 <- gsub("wouldnt use it","wouldnotuse",tolower(data2))
data2 <- gsub("wouldnt use","wouldnotuse",tolower(data2))
data2 <- gsub("too expensive","too expensive",tolower(data2))
data2 <- gsub("not willing","notwilling",tolower(data2))
data2 <- gsub("cost prohibitive","costprohibitive",tolower(data2))
data2 <- gsub("waste of time","wastetime",tolower(data2))
data2 <- gsub("i doubt","idoubt",tolower(data2))
data2 <- gsub("dont have much interest","donthavemuchinterest",tolower(data2))
data2 <- gsub("dont want","dontwant",tolower(data2))
data2 <- gsub("dont really have a need","dontreallyneed",tolower(data2))
data2 <- gsub("dont really need","dontreallyneed",tolower(data2))
data2 <- gsub("worry about added cost","worrycost",tolower(data2))
data2 <- gsub("will never work","neverwork",tolower(data2))
data2 <- gsub("not feasible","notfeasible",tolower(data2))
data2 <- gsub("i would not","iwouldnot",tolower(data2))
data2 <- gsub("i wouldnt","iwouldnot",tolower(data2))
data2 <- gsub("would rather","wouldrather",tolower(data2))
data2 <- gsub("id rather","idrather",tolower(data2))
data2 <- gsub("not in a position","notinaposition",tolower(data2))
data2 <- gsub("not a starbucks fan","notastarbucksfan",tolower(data2))
data2 <- gsub("i dont see the need","dontsee",tolower(data2))
data2 <- gsub("i dont see","dontsee",tolower(data2))
data2 <- gsub("dont see","dontsee",tolower(data2))
data2 <- gsub("wont be","wontbe",tolower(data2))
data2 <- gsub("i do not care","wontbe",tolower(data2))
data2 <- gsub("not something I would buy","notbuy",tolower(data2))
data2 <- gsub("wont stay","wontstay",tolower(data2))
data2 <- gsub("will not stay","wontstay",tolower(data2))
data2 <- gsub("will not stay fresh","wontstay",tolower(data2))
data2 <- gsub("wont stay fresh","wontstay",tolower(data2))
data2 <- gsub("cant imagine","cantimagine",tolower(data2))
data2 <- gsub("could not order","couldnotorder",tolower(data2))
data2 <- gsub("not interesting ","notinteresting",tolower(data2))
data2 <- gsub("not interesting","notinteresting",tolower(data2))
data2 <- gsub("dont really like","dontreallylike",tolower(data2))
data2 <- gsub("no opinion","noopinion",tolower(data2))
data2 <- gsub("i dont really have a need","noneed",tolower(data2))
data2 <- gsub("i never ever","neverever",tolower(data2))
data2 <- gsub("wasnt its best","neverever",tolower(data2))
data2 <- gsub("lost my attention","neverever",tolower(data2))
data2 <- gsub("just not there for me","neverever",tolower(data2))
data2 <- gsub("just not there","neverever",tolower(data2))
data2 <- gsub("waste of time and money","neverever",tolower(data2))
data2 <- gsub("waste of time","neverever",tolower(data2))
data2 <- gsub("how does it work","noneed",tolower(data2))
data2 <- gsub("will it work","noneed",tolower(data2))
data2 <- gsub("swears by it","swearsbyit",tolower(data2))

data2 <- gsub("might not feel very comfortable","no need",tolower(data2))

 





if (j==1) data2a=data2 else data2a=cbind(data2a,data2)


}

data2b=cbind(ids,data2a)

data2=data2a
#colnum=ncol(data2)

if (exists("runtype")) {
  if (runtype=="English") {

for (k in 1:(colnum/2)) {
if (k==1) data3=data.frame(paste(as.character(data2[,1]),as.character(data2[,2]))) else data3=cbind(data3,paste(as.character(data2[,(k-1)*2+1]),as.character(data2[,(k-1)*2+2])))
if (k==1) data3a=data.frame(paste(as.character(data1[,1]),"-----",as.character(data1[,2]))) else data3a=cbind(data3a,paste(as.character(data1[,(k-1)*2+1]),"-----",as.character(data1[,(k-1)*2+2])))
}
}}
    
if (exists("runtype")) {
  if (runtype=="native") {
    
    for (k in 1:(colnum/2)) {
      if (k==1) data3=data.frame(paste(as.character(data2[,1]),as.character(data2[,2]))) else data3=cbind(data3,paste(as.character(data2[,(k-1)*2+1]),as.character(data2[,(k-1)*2+2])))
      if (k==1) data3a=data.frame(paste(as.character(data1[,1]),as.character(data1[,2]))) else data3a=cbind(data3a,paste(as.character(data1[,(k-1)*2+1]),as.character(data1[,(k-1)*2+2])))
    }
  }}


    
#data3[data3==" "]=999

library(tm)
library(syuzhet)


#Import custom list
custom=read.csv(paste0(path,"custom.csv"))
names(custom)[1]="word"
names(custom)[2]="value"

#define custom list
custom_lexicon <- data.frame(word=custom$word, value=custom$value)


for (i in 1:(colnum/2)) {
out=data3[,i]  
syuzhet <- get_sentiment(as.character(out))
syuzhet_bing <- get_sentiment(as.character(out), method = "bing")
syuzhet_afinn <- get_sentiment(as.character(out), method = "afinn")
syuzhet_nrc <- get_sentiment(as.character(out), method = "nrc")
syuzhet_custom <- get_sentiment(as.character(out), method = "custom", lexicon = custom_lexicon)
syuzhet_types=get_nrc_sentiment(as.character(out))
syuzhet_types[,11]=rowSums(syuzhet_types)
names(syuzhet_types)[11]="Intensity"
syuzhet_types[,12]=sqrt(abs(syuzhet)+abs(syuzhet_bing)+abs(syuzhet_afinn)+abs(syuzhet_nrc) +abs(syuzhet_custom) + syuzhet_types[,11])/10
names(syuzhet_types)[12]="Intensity2"
syuzhet_all=cbind(syuzhet,syuzhet_bing,syuzhet_afinn,syuzhet_nrc,syuzhet_types)
temp1=syuzhet/abs(syuzhet+0.00000000001)*sqrt(abs(syuzhet))
temp2=syuzhet_afinn/abs(syuzhet_afinn+0.00000000001)*sqrt(abs(syuzhet_afinn))
temp3=syuzhet_bing/abs(syuzhet_bing+0.00000000001)*sqrt(abs(syuzhet_bing))
temp4=syuzhet_nrc/abs(syuzhet_nrc+0.00000000001)*sqrt(abs(syuzhet_nrc))
temp5=syuzhet_custom/abs(syuzhet_custom+0.00000000001)*sqrt(abs(syuzhet_custom))
temp1a=ifelse(temp1>0,temp1/2.9,-temp1/-2.3)
temp2a=ifelse(temp2>0,temp2/5,-temp2/-4)
temp3a=ifelse(temp3>0,temp3/3.6,-temp3/-3.3)
temp4a=ifelse(temp4>0,temp4/3.3,-temp4/-2.6)
temp5a=ifelse(temp5>0,temp5/1,-temp5/-1)

syuzhet_all[,17]=(temp1a+temp2a+temp3a+temp4a+temp5a)/5
names(syuzhet_all)[17]="Sentiment"
if (i==1) sentfinal=data.frame(syuzhet_all[,17]) else sentfinal=cbind(sentfinal,syuzhet_all[,17])
names(sentfinal)[i]=paste0("Sentiment_C",i)
if (i==1) intensity2=data.frame(syuzhet_all[,16]) else intensity2=cbind(intensity2,syuzhet_all[,16])


}


sentfinala=cbind(rownames(data1),sentfinal)
names(sentfinala)[1]="SentID"
if (exists("runtype")) {
  if (runtype=="English") {
  write.csv(sentfinala,file=outname,row.names = FALSE)
}}

# Save these variables for Native Language Sorting and Positive, Negative and Neutral
#ONLY run when running english (translated).  Do we need to save variables for the next run?

if (exists("runtype")) {
if (runtype=="English") {
sentfinalenglish=sentfinal
intensity2english=intensity2
write.csv(sentfinalenglish,paste0(path,"sentfinalenglish.csv"),row.names = FALSE)
write.csv(intensity2english,paste0(path,"intensity2english.csv"),row.names = FALSE)
}
}


#Use this code only when you run the native code and do NOt run code above.

if (exists("runtype")) {
if (runtype=="native") {
  sentfinal=read.csv(paste0(path,"sentfinalenglish.csv"))
  intensity2=read.csv(paste0(path,"intensity2english.csv"))

  
  }
}
  
if (exists("wb")) rm(wb)

if (exists("runtype")) {
  if (runtype=="English") { 
if (file.exists(paste0(path,"SentimentExceptsWCsEnglish.xlsx")))  file.remove(paste0(path,"SentimentExceptsWCsEnglish.xlsx"))

  }}
    
if (exists("runtype")) {
  if (runtype=="native") {   
if (file.exists(paste0(path,"SentimentExceptsWCsNative.xlsx")))  file.remove(paste0(path,"SentimentExceptsWCsNative.xlsx"))

  }}
    
wb=loadWorkbook(paste0(path,"SentimentExceptsWCsEnglish.xlsx") , create = TRUE )


if (exists("runtype")) {
if (runtype=="native") {
wb=loadWorkbook(paste0(path,"SentimentExceptsWCsNative.xlsx") , create = TRUE )
}
}

incols=colSums(sentfinal)>0

for (l in 1:ncol(sentfinal)) {
  if (incols[l]) {
  
  rnum=100000*as.numeric(Sys.time())
  createSheet(wb, name = paste0("Concept",l))
  
  temppos=data.frame(cbind(ids[sentfinal[,l]>0.025],as.character(data3[sentfinal[,l]>0.025,l]),intensity2[sentfinal[,l]>0.025,l],sentfinal[sentfinal[,l]>0.025,l]))
  tempposa=data.frame(cbind(ids[sentfinal[,l]>0.025],as.character(data3a[sentfinal[,l]>0.025,l]),intensity2[sentfinal[,l]>0.025,l],sentfinal[sentfinal[,l]>0.025,l]))
  
  test123=temppos[order(temppos[,3],decreasing=TRUE),]
  test123=test123[,1:2]
  test123b=tempposa[order(tempposa[,3],decreasing=TRUE),]
  test123b=test123b[,1:2]
  #names(test123)=c("ids","Statement","Intensity","Sentiment")
  names(test123)=c("ids","Positive Statements")
  names(test123b)=c("ids","Positive Statements")
  
  if (exists("runtype")) {
    if (runtype=="English") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 1)
    }}
  
  if (exists("runtype")) {
    if (runtype=="native") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 1)
    }}
  

  test123a=test123[test123[,2]!=""&test123[,2]!=" "&test123[,2]!="  "&test123[,2]!="   "&test123[,2]!="    "&!is.na(test123[,2]),2]
  if (length(test123a)>5)
    #if (sum(sentfinal[,l]>0) >= 10) 
    {
    jpeg(paste0(path,'WCPos',l,'.jpg'))
 #   wordcloud(data3[sentfinal[,l]>0,l], min.freq = 2, max.words=300, random.order = FALSE,colors=brewer.pal(9,"BuGn")[0:-3])
    if (runtype=="native") {
      words <- Corpus(VectorSource(test123b[,2]))
    wordcloud((words), min.freq = minfreq, max.words=300, random.order = FALSE, colors=brewer.pal(9,"BuGn")[0:-3])
    }   else {
      test123c=test123b
      test123c[,2] <- gsub("-----","",tolower(test123c[,2]))
      wordcloud((as.character(test123c[,2])), min.freq = minfreq, max.words=300, random.order = FALSE, colors=brewer.pal(9,"BuGn")[0:-3])      
      }
    
    dev.off()

   # write.csv(test123,paste0('SentOutPos',l,'.csv'))
    

    #createSheet(wb, name = paste0("Concept",l))
 
    createName(wb, name = paste0("Imagea",l,rnum), formula = paste0("Concept",l,"!$f$2"))

   addImage(wb, filename = paste0(path,"WCPos",l,".jpg"), name = paste0("Imagea",l,rnum),originalSize = TRUE)
    #saveWorkbook(wb)
    
    file.remove(paste0(path,"WCPos",l,".jpg"))
  }
  cutoff2=0.0249999
  temppos=  data.frame(cbind(ids[abs(sentfinal[,l])<=cutoff2],as.character(data3[abs(sentfinal[,l])<=cutoff2,l]),intensity2[abs(sentfinal[,l])<=cutoff2,l],sentfinal[abs(sentfinal[,l])<=cutoff2,l]))
  tempposa=data.frame(cbind(ids[abs(sentfinal[,l])<=cutoff2],as.character(data3a[abs(sentfinal[,l])<=cutoff2,l]),intensity2[abs(sentfinal[,l])<=cutoff2,l],sentfinal[abs(sentfinal[,l])<=cutoff2,l]))
  test123=temppos[order(temppos[,2],decreasing=TRUE),]
  test123=test123[,1:2]
  test123b=tempposa[order(tempposa[,2],decreasing=TRUE),]
  test123b=test123b[test123b[,2]!=" ----- ",1:2]
  test123b=test123b[test123b[,2]!=" ",1:2]
  #names(test123)=c("ids","Statement","Intensity","Sentiment")
  names(test123)=c("ids","Neutral Statements")
  names(test123b)=c("ids","Neutral Statements")
  if (exists("runtype")) {
    if (runtype=="English") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 15)
    }}
  
  if (exists("runtype")) {
    if (runtype=="native") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 15)
    }}
  
  test123a=test123[test123[,2]!=""&test123[,2]!=" "&test123[,2]!="  "&test123[,2]!="   "&test123[,2]!="    "&!is.na(test123[,2]),2]
  
  if (length(test123a)>5)
  #if (sum(sentfinal[,l]==0) >= 10)
  {
    jpeg(paste0(path,'WC0',l,'.jpg'))
    
    if (runtype=="native") {
      words <- Corpus(VectorSource(test123b[,2]))
      wordcloud(words, min.freq = minfreq, max.words=300, random.order = FALSE, colors=brewer.pal(9,"Greys")[0:-3])
    }   else {
      test123c=test123b
      test123c[,2] <- gsub("-----","",tolower(test123c[,2]))
      wordcloud((as.character(test123b[,2])), min.freq = minfreq, max.words=300, random.order = FALSE, colors=brewer.pal(9,"Greys")[0:-3])  
    }
    

    
    #wordcloud(data3[sentfinal[,l]==0,l], min.freq = 2, max.words=300, random.order = FALSE,colors=brewer.pal(9,"Greys")[0:-3])
    dev.off()

   # write.csv(test123,paste0('SentOut0',l,'.csv'))
    
   # createSheet(wb, name = paste0("Concept",l))
   # createName(wb, name = paste0("Image",l), formula = paste0("Concept",l,"!$f$2"))
    createName(wb, name = paste0("Imageb",l,rnum), formula = paste0("Concept",l,"!$s$2"))

    addImage(wb, filename = paste0(path,"WC0",l,".jpg"), name = paste0("Imageb",l,rnum),originalSize = TRUE)
    file.remove(paste0(path,"WC0",l,".jpg"))
    
  }
  temppos=data.frame(cbind(ids[sentfinal[,l]<=-0.025],as.character(data3[sentfinal[,l]<=-0.025,l]),intensity2[sentfinal[,l]<=-0.025,l],sentfinal[sentfinal[,l]<=-0.025,l]))
  tempposa=data.frame(cbind(ids[sentfinal[,l]<=-0.025],as.character(data3a[sentfinal[,l]<=-0.025,l]),intensity2[sentfinal[,l]<=-0.025,l],sentfinal[sentfinal[,l]<=-0.025,l]))
  test123=temppos[order(temppos[,3],decreasing=TRUE),]
  test123=test123[,1:2]
  test123b=tempposa[order(tempposa[,3],decreasing=TRUE),]
  test123b=test123b[,1:2]
  #names(test123)=c("ids","Statement","Intensity","Sentiment")
  names(test123)=c("ids","Negative Statements")
  names(test123b)=c("ids","Negative Statements")
  
  if (exists("runtype")) {
    if (runtype=="English") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 30)
    }}
  
  if (exists("runtype")) {
    if (runtype=="native") {
      
      writeWorksheet(wb, test123b, sheet = paste0("Concept",l), startRow = 1, startCol = 30)
    }}
  
  
  test123a=test123[test123[,2]!=""&test123[,2]!=" "&test123[,2]!="  "&test123[,2]!="   "&test123[,2]!="    "&!is.na(test123[,2]),2]
  if (length(test123a)>5)
  #if (sum(sentfinal[,l]<0) >= 10) 
    {
    jpeg(paste0(path,'WCNeg',l,'.jpg'))
    
    if (runtype=="native") {
      words <- Corpus(VectorSource(test123b[,2]))
      wordcloud(words, min.freq = minfreq, max.words=300, random.order = FALSE ,colors=brewer.pal(9,"Reds")[0:-3])
      
    }   else {
      test123c=test123b
      test123c[,2] <- gsub("-----","",tolower(test123c[,2]))
      wordcloud((as.character(test123b[,2])), min.freq = minfreq, max.words=300, random.order = FALSE ,colors=brewer.pal(9,"Reds")[0:-3])
        
    }
    
    dev.off()
    
    
        

  #  write.csv(test123,paste0('SentOutNeg',l,'.csv'))
    createName(wb, name = paste0("Imagec",l,rnum), formula = paste0("Concept",l,"!$aj$2"))

    addImage(wb, filename = paste0(path,"WCNeg",l,".jpg"), name = paste0("Imagec",l,rnum),originalSize = TRUE)
    #dev.off()
    file.remove(paste0(path,"WCNeg",l,".jpg"))
    
  }
  }
}
saveWorkbook(wb)
#dev.off()
#file.remove(paste0(path,"WCNeg",l,".jpg"))




