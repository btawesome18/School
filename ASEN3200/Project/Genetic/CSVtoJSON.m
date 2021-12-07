constellation.companyName = "Beyond Space";
constellation.companyExecutives = ['A','B','C'];
load("Champ.csv");
[a,~] =size(Champ);
for i = 1:a
    constellation.launches(i).launchName = Champ(i,1);
    constellation.launches(i).orbit.a =  Champ(i,2);
    constellation.launches(i).orbit.e =  Champ(i,3);
    constellation.launches(i).orbit.i =  Champ(i,4);
    constellation.launches(i).orbit.Om =  Champ(i,5);
    constellation.launches(i).orbit.om =  Champ(i,6);
    E = 0:((2*pi)/Champ(i,7)):(2*pi);
    for j = 1:1:(Champ(i,7))
        %norm = (2*pi)/Champ(i,7);
        constellation.launches(i).payload(j).name = j;
        constellation.launches(i).payload(j).f = atan(sqrt((1+Champ(i,3))/(1-Champ(i,3)))*tan(E(j)/2))*2;
        
    end
    
end

saveJSONfile(constellation,"Constilation.json");

function saveJSONfile(data, jsonFileName)
% saves the values in the structure 'data' to a file in JSON format.
%
% Example:
%     data.name = 'chair';
%     data.color = 'pink';
%     data.metrics.height = 0.3;
%     data.metrics.width = 1.3;
%     saveJSONfile(data, 'out.json');
%
% Output 'out.json':
% {
% 	"name" : "chair",
% 	"color" : "pink",
% 	"metrics" : {
% 		"height" : 0.3,
% 		"width" : 1.3
% 		}
% 	}
%
    fid = fopen(jsonFileName,'w');
    %fid=1;
    writeElement(fid, data,'');
    fprintf(fid,'\n');
    fclose(fid);
end
% function buildJSON(fid,data)
%     namesOfFields = fieldnames(data);
%     numFields = length(namesOfFields);
%     
%     if isstruct(
%     fprintf(fid,'{ "%s" : [\n ',rootElementName);
%     for m = 1:length(data) - 1
%        fprintf(fid,'{  \n ');
%        writeSingleGene(fid,numFields, namesOfFields,dataname,data,m);
%        fprintf(fid,'},\n');
%     end
%     m= m+1;
%     fprintf(fid,'{  \n ');
%     writeSingleGene(fid, numFields, namesOfFields,dataname,data,m);
%     fprintf(fid,' }\n]\n');
%     
%    
%     end
function writeElement(fid, data,tabs)
    namesOfFields = fieldnames(data);
    numFields = length(namesOfFields);
    tabs = sprintf('%s\t',tabs);
    fprintf(fid,'{\n%s',tabs);
   
    for i = 1:numFields - 1
        currentField = namesOfFields{i};
        currentElementValue = eval(sprintf('data.%s',currentField));
        writeSingleElement(fid, currentField,currentElementValue,tabs);
        fprintf(fid,',\n%s',tabs);
    end
    if isempty(i)
        i=1;
    else
      i=i+1;
    end
      
    
    currentField = namesOfFields{i};
    currentElementValue = eval(sprintf('data.%s',currentField));
    writeSingleElement(fid, currentField,currentElementValue,tabs);
    fprintf(fid,'\n%s}',tabs);
end
function writeSingleElement(fid, currentField,currentElementValue,tabs)
    
        % if this is an array and not a string then iterate on every
        % element, if this is a single element write it
        if length(currentElementValue) > 1 && ~ischar(currentElementValue)
            fprintf(fid,' "%s" : [\n%s',currentField,tabs);
            for m = 1:length(currentElementValue)-1
                writeElement(fid, currentElementValue(m),tabs);
                fprintf(fid,',\n%s',tabs);
            end
            if isempty(m)
                m=1;
            else
              m=m+1;
            end
            
            writeElement(fid, currentElementValue(m),tabs);
          
            fprintf(fid,'\n%s]\n%s',tabs,tabs);
        elseif isstruct(currentElementValue)
            fprintf(fid,'"%s" : ',currentField);
            writeElement(fid, currentElementValue,tabs);
        elseif isnumeric(currentElementValue)
            fprintf(fid,'"%s" : %g' , currentField,currentElementValue);
        elseif isempty(currentElementValue)
            fprintf(fid,'"%s" : null' , currentField,currentElementValue);
        else %ischar or something else ...
            fprintf(fid,'"%s" : "%s"' , currentField,currentElementValue);
        end
end
% function writeSingleGene(fid,numFields, namesOfFields,dataname,data,m)
% 
%     for i = 1:numFields - 1
%         field = namesOfFields{i};
%         stmp = sprintf('%s(m).%s',dataname,field);
%         fprintf(fid,'"%s" : "%s",\n' , field,eval(stmp));
%     end
%     i=i+1;
%     field = namesOfFields{i};
%     stmp = sprintf('%s(m).%s',dataname,field);
%     fprintf(fid,'"%s" : "%s"\n',field,eval(stmp));
%         
%         
% end