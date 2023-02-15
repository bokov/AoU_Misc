library(rio);
library(googlesheets4);

# This is a script that pulls the AoU survey codebook and extracts questions
# meeting a particular criteria. Currently, questions about the participant's
# recent past as identified by containing one or more of days/weeks/months/years
# together with one or more of the work 'past' or 'last'. This seems to capture
# all the different ways that they phrased questions having the pattern of:
#    "During the last X months, did you ... ?"

gs4_auth();

inputdata <- c(
  codebook = 'https://docs.google.com/spreadsheets/d/15b4KEchI9fUcaG42DVEf9ikl6UpVtdM0GZrjFMKMrR4/edit?usp=sharing'
)

props <- read_sheet(inputdata['codebook']);
sapply(props$name[-1], print)
cb <- sapply(props$name[-1], function(xx) read_sheet(inputdata['codebook'],sheet=xx),simplify=F);

q_inthepast <-  sapply(cb,function(xx) grep('past|last',xx$`Field Label`
                                            ,ignore.case=T,val=T)) %>%
  sapply(function(xx) grep('(week|month|year|day)s?',xx,val=T,ign=T)) %>%
  {sapply(names(.),function(xx) if(length((.)[[xx]])>0){
    data.frame(survey=xx,question=(.)[[xx]])})} %>%
  do.call(bind_rows,.);

export(q_inthepast,'AoU_questions_recentpast.xlsx');