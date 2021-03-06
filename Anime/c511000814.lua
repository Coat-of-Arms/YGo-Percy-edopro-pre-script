--Extra Fusion
function c511000814.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000814.target)
	e1:SetOperation(c511000814.activate)
	c:RegisterEffect(e1)
end
function c511000814.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c511000814.filter2(c,e,tp,m,f)
	if not c:IsType(TYPE_FUSION) or (f and not f(c)) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then return false end
	m:RemoveCard(c)
	local chk=c:CheckFusionMaterial(m,nil,tp)
	m:AddCard(c)
	return chk
end
function c511000814.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_EXTRA,0,nil)
		local res=Duel.IsExistingMatchingCard(c511000814.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c511000814.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000814.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c511000814.filter1,tp,LOCATION_EXTRA,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c511000814.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c511000814.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if mg2~=nil and mg2:GetCount()>0 then
			mg2:RemoveCard(tc)
		end
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
