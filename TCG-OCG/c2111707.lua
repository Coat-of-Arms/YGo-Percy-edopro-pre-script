--XY－ドラゴン・キャノン
function c2111707.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(true,true,62651957,65622692)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c2111707.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c2111707.spcon)
	e2:SetOperation(c2111707.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2111707,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c2111707.descost)
	e3:SetTarget(c2111707.destg)
	e3:SetOperation(c2111707.desop)
	c:RegisterEffect(e3)
end
function c2111707.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE)
end
function c2111707.spfilter(c,code)
	return c:IsFusionCode(code) and c:IsAbleToRemoveAsCost()
end
function c2111707.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,nil,62651957)
	local g2=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,nil,65622692)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if g1:GetCount()==1 and g2:GetCount()==1 and g1:GetFirst()==g2:GetFirst() then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c2111707.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,nil,62651957)
	local g2=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,nil,65622692)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
			ft=ft+1
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		if i==1 then
			g1:Clear()
			if tc:IsFusionCode(65622692) then
				local sg=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,tc,62651957)
				g1:Merge(sg)
			end
			if tc:IsFusionCode(62651957) then
				local sg=Duel.GetMatchingGroup(c2111707.spfilter,tp,LOCATION_ONFIELD,0,tc,65622692)
				g1:Merge(sg)
			end
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c2111707.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c2111707.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c2111707.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c2111707.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2111707.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2111707.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c2111707.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
