--Underworld Resonance - Synchro Fusion
function c511002620.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002620.target)
	e1:SetOperation(c511002620.activate)
	c:RegisterEffect(e1)
end
function c511002620.fusfilter(c,e,tp,g)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and Duel.IsExistingMatchingCard(c511002620.synfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,g,c)
end
function c511002620.synfilter(c,e,tp,g,fc)
	return c:IsType(TYPE_SYNCHRO) and g:IsExists(c511002620.filterchk,1,nil,g,Group.CreateGroup(),e,tp,fc,c)
end
function c511002620.filter(c,e)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial() and c:IsCanBeFusionMaterial() and (not e or not c:IsImmuneToEffect(e))
end
function c511002620.filterchk(c,g,sg,e,tp,fc,sc)
	sg:AddCard(c)
	local res=c511002620.matchk(fc,sc,sg,tp)
		or sg:IsExists(c511002620.filterchk,1,sg,g,sg,e,tp)
	e3:Reset()
	sg:RemoveCard(c)
	return res
end
function c511002620.matchk(fc,sc,sg,tp)
	local t={}
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_MUST_BE_SMATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		t[tc]=e1
		tc=sg:GetNext()
	end
	local res=fc:CheckFusionMaterial(sg,nil,tp) and sc:IsSynchroSummonable(nil,sg)
	tc=sg:GetFirst()
	while tc do
		t[tc]:Reset()
		tc=sg:GetNext()
	end
	return res
end
function c511002620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c511002620.filter,tp,LOCATION_MZONE,0,nil)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return (not ect or ect>=2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsExistingMatchingCard(c511002620.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c511002620.activate(e,tp,eg,ep,ev,re,r,rp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,29724053) or (ect and ect<2) then return end
	local g=Duel.GetMatchingGroup(c511002620.filter,tp,LOCATION_MZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,c511002620.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst()
	if not fc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c511002620.synfilter,tp,LOCATION_EXTRA,0,1,1,fc,e,tp,g,fc):GetFirst()
	local mat=Group.CreateGroup()
	::start::
		local cancel=mat:GetCount()>0 and c511002620.matchk(fc,sc,mat,tp)
		local g=cg:Filter(c511002620.filterchk,mat,g,mat,e,tp,fc,sc)
		if g:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(g,mat,tp,cancel,cancel)
		if not tc then goto jump end
		if mat:IsContains(tc) then
			mat:RemoveCard(tc)
		else
			mat:AddCard(tc)
		end
		goto start
	::jump::
	fc:SetMaterial(mat)
	sc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_SYNCHRO)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
	fc:CompleteProcedure()
	sc:CompleteProcedure()
end
