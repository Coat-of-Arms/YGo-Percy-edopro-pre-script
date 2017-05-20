--エルシャドール・シェキナーガ
function c74822425.initial_effect(c)
	c:EnableReviveLimit()
	c74822425.min_material_count=2
	c74822425.max_material_count=2
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c74822425.fuscon)
	e1:SetOperation(c74822425.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c74822425.splimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74822425,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,74822425)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c74822425.discon)
	e3:SetTarget(c74822425.distg)
	e3:SetOperation(c74822425.disop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(74822425,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c74822425.thtg)
	e4:SetOperation(c74822425.thop)
	c:RegisterEffect(e4)
end
function c74822425.ffilter1(c)
	return (c:IsFusionSetCard(0x9d) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c74822425.ffilter2(c)
	return not c:IsHasEffect(6205579) and (c:IsHasEffect(511002961) or c:IsFusionAttribute(ATTRIBUTE_EARTH) or c:IsHasEffect(4904633))
end
function c74822425.exfilter(c,g,fc)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(fc) and not g:IsContains(c) and (c74822425.ffilter1(c) or c74822425.ffilter2(c))
end
function c74822425.ffilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and (c74822425.ffilter1(c) or c74822425.ffilter2(c))
end
function c74822425.FCheckGoal(tp,sg,fc)
	local g=Group.CreateGroup()
	return sg:IsExists(c74822425.FCheck,1,nil,sg,g,c74822425.ffilter1,c74822425.ffilter2) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
end
function c74822425.FCheck(c,tp,mg,sg,fun1,fun2)
	if fun2 then
		sg:AddCard(c)
		mg:RemoveCard(c)
		local res=fun1(c,tp) and mg:IsExists(c74822425.FCheck,1,sg,mg,sg,fun2)
		sg:RemoveCard(c)
		mg:AddCard(c)
		return res
	else
		return fun1(c,tp)
	end
end
function c74822425.filterchk(c,tp,mg,mg2,sg,fc)
	sg:AddCard(c)
	mg:RemoveCard(c)
	if mg2:IsContains(c) then
		mg:Sub(mg2)
	end
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not aux.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	if sg:GetCount()<2 then
		res=mg:IsExists(c74822425.filterchk,1,tp,mg,mg2,sg,fc)
	else
		res=c74822425.FCheckGoal(tp,sg,fc)
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	mg:Merge(mg2)
	return res
end
function c74822425.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local c=e:GetHandler()
	local mg=g:Filter(c74822425.ffilter,nil,c)
	local sg=Group.CreateGroup()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		sg=Duel.GetMatchingGroup(c74822425.exfilter,tp,0,LOCATION_MZONE,nil,g)
		mg:Merge(sg)
	end
	if gc then
		return mg:IsContains(gc) and c74822425.filterchk(gc,tp,mg,sg,Group.CreateGroup(),c)
	end
	local sg2=Group.CreateGroup()
	return mg:IsExists(c74822425.filterchk,1,nil,tp,mg,sg,sg2,c)
end
function c74822425.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(c100000622.ffilter,nil,c)
	local p=tp
	local sfhchk=false
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c74822425.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc) mg:RemoveCard(gc)
		if gc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(aux.TuneMagFilterFus,gc,eff[i],f)
			end
		end
		if exg:IsContains(gc) then mg:Sub(exg) fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
	end			
	if gc then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local g1=mg:FilterSelect(p,c74822425.filterchk,1,1,gc,tp,mg,exg,sg,c)
		if exg:IsContains(g1:GetFirst()) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		end
	else
		while sg:GetCount()<2 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			local tc=Group.SelectUnselect(mg:Filter(c74822425.filterchk,sg,tp,mg,exg,sg,c),sg,p)
			if not tc then break end
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			else
				sg:RemoveCard(tc)
			end
			if tc:IsHasEffect(73941492+TYPE_FUSION) then
				local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
				for i=1,#eff do
					local f=eff[i]:GetValue()
					mg=mg:Filter(aux.TuneMagFilterFus,tc,eff[i],f)
				end
			end
			if exg:IsContains(tc) then mg:Sub(exg) fc:RemoveCounter(tp,0x16,3,REASON_EFFECT) end
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(g1)
end
function c74822425.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c74822425.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and Duel.IsChainNegatable(ev)
end
function c74822425.filter(c)
	return c:IsSetCard(0x9d)
end
function c74822425.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74822425.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c74822425.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c74822425.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c74822425.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c74822425.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c74822425.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74822425.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c74822425.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c74822425.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
