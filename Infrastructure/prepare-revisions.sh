#!/bin/bash
COMMITHASH=$1

echo "Starting script...Commit Hash received $COMMITHASH"
az config set extension.use_dynamic_install=yes_without_prompt
az extension add -n containerapp

nextRevisionName="xeniel-frontend--${COMMITHASH:0:10}"
previousRevisionName=$(az containerapp revision list -n xeniel-frontend -g xeniel --query '[0].name')

prevNameWithoutQuites=$(echo $previousRevisionName | tr -d "\"")        # using sed echo $pname | sed "s/\"//g"
echo 'Previous revision name: ' $prevNameWithoutQuites
echo 'Next revision name: ' $nextRevisionName

# az deployment group create \ 
#    --resource-group xeniel \
#    --template-file frontend.bicep \
#    --parameters tagName="$COMMITHASH" latestRevisionName="$nextRevisionName" previousRevisionName="$prevNameWithoutQuites"




# echo "{AZCAP_PREV_REV}={$previousRevisionName}" >> $GITHUB_ENV
# echo "{AZCAP_NEXT_REV}={$nextRevisionName}" >> $GITHUB_ENV
# echo "$GITHUB_ENV"
# cat $GITHUB_ENV


# sed 's/PREV/'$previousRevisionName'/g;s/NEXT/'$nextRevisionName'/g' ${PWD}/Infrastructure/ts.template > ${PWD}/Infrastructure/ts.tmp
# sed "s/\"/'/g" ${PWD}/Infrastructure/ts.tmp > ${PWD}/Infrastructure/ts.json
# cat ${PWD}/Infrastructure/ts.json

# TrafficSpec=$(cat ${PWD}/Infrastructure/ts.json)

# echo "TrafficSpec: $TrafficSpec"

sed -i "s/PREV/$prevNameWithoutQuites/g" ${PWD}/Infrastructure/frontend.bicep 
sed -i "s/NEXT/$nextRevisionName/g" ${PWD}/Infrastructure/frontend.bicep 


cat ${PWD}/Infrastructure/frontend.bicep