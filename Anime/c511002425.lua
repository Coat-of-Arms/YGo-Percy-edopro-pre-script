--モザイク・マンティコア
function c511002425.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,511002422,511002423,511002424)
	aux.AddContactFusion(c,c511002425.contactfilter,c511002425.contactop)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c511002425.splimit)
	c:RegisterEffect(e1)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(102380,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c511002425.destg)
	e3:SetOperation(c511002425.desop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75347539,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c511002425.spcost2)
	e4:SetTarget(c511002425.sptg2)
	e4:SetOperation(c511002425.spop2)
	c:RegisterEffect(e4)
end
function c511002425.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c511002425.contactfilter(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c511002425.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c511002425.filter(c,e,tp)
	return c:IsCode(511002422) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,e:GetHandler():GetPreviousControler()) 
		and Duel.IsExistingMatchingCard(c511002425.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,e,tp)
end
function c511002425.filter2(c,e,tp)
	return c:IsCode(511002423) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,e:GetHandler():GetPreviousControler())
end
function c511002425.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c511002425.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local p=e:GetHandler():GetPreviousControler()
	if Duel.GetLocationCount(p,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c511002425.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=Duel.SelectMatchingCard(tp,c511002425.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,sg1:GetFirst(),e,tp)
	sg1:Merge(sg2)
	if sg1:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	Duel.SpecialSummon(sg1,0,tp,p,false,false,POS_FACEUP)
end
function c511002425.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c511002425.spfilterx(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002425.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsExistingTarget(c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,nil,e,tp,511002423)
		and Duel.IsExistingTarget(c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,nil,e,tp,511002424)
		and Duel.IsExistingTarget(c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,nil,e,tp,511002422) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,511002423)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,511002424)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c511002425.spfilterx,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,511002422)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c511002425.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()~=3 or ft<3 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end