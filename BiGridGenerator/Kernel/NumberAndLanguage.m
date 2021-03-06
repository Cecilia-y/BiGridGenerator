(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: NumberAndLanguage *)
(* :Context: NumberAndLanguage` *)
(* :Author: GalAster *)
(* :Date: 2016-04-12 *)

(* :Package Version: 0.5 *)
(* :Update: 2016-10-21 *)
(* :Mathematica Version: 11.0+ *)
(* :Copyright:该软件包遵从CC协议:BY+NA+NC(署名、非商业性使用、相同方式共享） *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["NumberAndLanguage`"];




Begin["`Private`"];
简体中文小写={{零,13},{一,1},{二,2},{三,3},{四,5},{五,4},{六,4},{七,2},{八,2},{九,2},{十,2},{百,6},{千,3},{万,3}};
简体中文大写={{零,13},{壹,12},{贰,9},{叁,8},{肆,13},{伍,6},{陆,7},{柒,9},{捌,10},{玖,7},{拾,10},{佰,8},{仟,5},{万,3}};
繁体中文数字={{零,13},{壹,12},{貳,9},{三,3},{肆,13},{伍,6},{陸,10},{柒,9},{捌,10},{玖,7},{拾,10},{佰,8},{仟,5},{萬,12}};
R=简体中文小写;
关联=Association@(Function[{x,y},x->y]@@@R);
ChineseToNumber[s_String]:=Total[关联/@ToExpression/@StringPartition[s,1]]
NumberToChinese[n_Integer/;0<=n<=10]:=ToString@R[[n+1,1]]
NumberToChinese[n_Integer/;11<=n<=19]:=ToString@R[[11,1]]<>ToString@R[[n-9,1]];
NumberToChinese[n_Integer/;20<=n<=99]:=StringDelete[ToString@R[[Floor[n,10]/10+1,1]]<>ToString@R[[11,1]]<>ToString@R[[Mod[n,10]+1,1]],"零"];
辅助表0=f0={""};
辅助表1=f1=Function[{x,y},x<>y]@@@Transpose@{ConstantArray["零",9],NumberToChinese/@Range@9};
辅助表2=f2=Function[{x,y},x<>y]@@@Transpose@{ConstantArray[ToString@R[[2,1]],10],NumberToChinese/@Range[10,19]};
NumberToChinese[n_Integer/;100<=n<=999]:=ToString@R[[Floor[n,100]/100+1,1]]<>ToString@R[[12,1]]<>Join[f0,f1,f2,NumberToChinese/@Range[20,99]][[Mod[n,100]+1]];
辅助表3=f3=Join[f0,f1,Function[{x,y},x<>y]@@@Transpose@{ConstantArray["零",10],f2},Function[{x,y},x<>y]@@@Transpose@{ConstantArray["零",80],NumberToChinese/@Range[20,99]}];
NumberToChinese[n_Integer/;1000<=n<=9999]:=ToString@R[[Floor[n,1000]/1000+1,1]]<>ToString@R[[13,1]]<>Join[f3,NumberToChinese/@Range[100,999]][[Mod[n,1000]+1]];
ResChinese=Graph[#\[DirectedEdge]ChineseToNumber@NumberToChinese@#&/@Range[0,99],VertexLabels->Placed["Name",Center],
  VertexLabelStyle->Directive[12,Lighter@Blue,Bold],VertexSize->0.8,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];

AusEnglish1={"","one","two","three","four","five","six","seven","eight","nine"};
AusEnglish2={"ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen","twenty"};
AusEnglish3={"twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"};
EnglishToNumber[s_String]:=StringLength@s;
NumberToEnglish[n_Integer/;1<=n<=19]:=StringDelete[(AusEnglish1~Join~AusEnglish2)[[n+1]],"-"]
AusEnglish4={"","-one","-two","-three","-four","-five","-six","-seven","-eight","-nine"};
NumberToEnglish[n_Integer/;20<=n<=99]:=AusEnglish3[[Floor[n,10]/10-1]]<>AusEnglish4[[Mod[n,10]+1]]
NumberToEnglish[n_/;100<=n<=999&&Mod[n,100]===0]:=AusEnglish1[[Floor[n,100]/100+1]]<>"hundred";
NumberToEnglish[n_Integer/;100<=n<=999]:=AusEnglish1[[Floor[n,100]/100+1]]<>"hundredand"<>NumberToEnglish[Mod[n,100]]
AusEnglish5=Join[{""},(Function[{x,y},x<>y]@@@Transpose@{ConstantArray["and",99],NumberToEnglish/@Range@99}),NumberToEnglish/@Range[100,999]];
NumberToEnglish[n_Integer/;1000<=n<=9999]:=AusEnglish1[[Floor[n,1000]/1000+1]]<>"thousand"<>AusEnglish5[[Mod[n,1000]+1]]
ResEnglish=Graph[#\[DirectedEdge]EnglishToNumber@NumberToEnglish@#&/@Range[1,100],VertexLabels->Placed["Name",Center],
  VertexLabelStyle->Directive[12,Lighter@Blue,Bold],VertexSize->0.8,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];

音読み={"れい","いち","に","さん","し","ご","ろく","しち","はち","く","じゅう","ひゃく"};
训読み={"まる","ひと","ふた","み","よ","いつ","む","なな","や","ここの","と","もも"};
筆画={{}};
(*"ローマ字"会被识别为以"ロ"和"ー"为自变量的函数...迷*)
罗马音={{"れ","re"},{"い","i"},{"ち","chi"},{"に","ni"},{"さ","sa"},
  {"ん","n"},{"し","shi"},{"ご","go"},  {"ろ","ro"},{"く","ku"},
  {"は","ha"},{"じ","ji"},{"ゅ","yu"},{"う","u"},  {"ひ","hi"},
  {"ゃ","ya"},{"ま","ma"},{"る","ru"},{"と","to"},{"ふ","fu"},
  {"た","ta"},{"み","mi"},{"よ","yo"},{"つ","tsu"},{"む","mu"},
  {"な","na"},{"や","ya"},{"こ","ko"},{"の","no"},{"も","mo"}};
関=Association@(Function[{x,y},x->y]@@@Transpose@{(Transpose@罗马音)[[1]],StringLength/@(Transpose@罗马音)[[2]]});
NumberToJapanese[n_Integer/;0<=n<=10]:=训読み[[n+1]]
JapaneseToNumber[s_String]:=Total[関/@Characters@s];
ResJapanese=Graph[#\[DirectedEdge]JapaneseToNumber@NumberToJapanese@#&/@Range[0,10],VertexLabels->Placed["Name",Center],
  VertexLabelStyle->Directive[12,Lighter@Blue,Bold],VertexSize->0.2,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];

ResRoman=Graph[#\[DirectedEdge]StringLength@RomanNumeral@#&/@Range[0,50],VertexLabels->Placed["Name",Center],
  VertexLabelStyle->Directive[12,Lighter@Blue,Bold],VertexSize->0.6,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];

拼音={{"零","líng"},{"一","yī"},{"二","èr"},{"三","sān"},{"四","sì"},{"五","wǔ"},{"六","liù"},
  {"七","qī"},{"八","bā"},{"九","jiǔ"},{"十","shí"},{"百","bǎi"},{"千","qiān"},{"万","wàn"}};
数位=Association@(Function[{x,y},x->y]@@@Transpose@{(Transpose@拼音)[[1]],StringLength/@(Transpose@拼音)[[2]]});
NumberToPinyin[n_Integer/;0<=n<=50]:=NumberToChinese@n;
PinyinToNumber[s_String]:=Total[数位/@Characters@s];
ResPinyin=Graph[#\[DirectedEdge]PinyinToNumber@NumberToPinyin@#&/@Range[0,50],VertexLabels->Placed["Name",Center],
  VertexLabelStyle->Directive[12,Lighter@Blue,Bold],VertexSize->0.6,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];

AuxGerman1={"null"}
AuxGerman2={"eins","zwei","drei","vier","fünf","sechs","sieben","acht","neun"}
AuxGerman3={"zehn","elf","zwölf","dreizehn","vierzehn","fünfzehn","sechzehn","siebzehn","achtzehn","neunzehn","zwanzig"}
GermanToNumber[s_String]:=StringLength@s;
NumberToGerman[n_Integer/;0<=n<=20]:=Join[AuxGerman1,AuxGerman2,AuxGerman3][[n+1]]
NumberToGerman[30]:="dreißig"
NumberToGerman[n_Integer/;31<=n<=39]:=AuxGerman2[[Mod[n,10]]]<>"unddreißig"
NumberToGerman[n_/;40<=n<=99&&Mod[n,10]===0]:=AuxGerman2[[n/10]]<>"zig";
NumberToGerman[n_Integer/;21<=n<=99]:=AuxGerman2[[Mod[n,10]]]<>"und"<>AuxGerman2[[Floor[n,10]/10]]<>"zig"
ResGerman=Graph[#\[DirectedEdge]GermanToNumber@NumberToGerman@#&/@Range[0,49],VertexLabels->Placed["Name",Center],VertexLabelStyle->Directive[12,Lighter@Blue,Bold],
  VertexSize->0.6,EdgeShapeFunction->GraphElementData["ShortFilledArrow","ArrowSize"->0.01],
  GraphLayout->"SpringElectricalEmbedding",ImageSize->Full];
End[];



SetAttributes[{},Listable];
SetAttributes[{},Protected];
SetAttributes[{},ReadProtected];
SetAttributes[{},Locked];
EndPackage[]