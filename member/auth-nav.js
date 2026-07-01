import { getSupabaseClient } from "/member/supabase-config.js";

function labelFromUser(user){
  const meta=user?.user_metadata||{};
  return meta.name||user?.email||"회원";
}

function escapeHtml(value){
  return String(value).replace(/[&<>"']/g,(ch)=>({
    "&":"&amp;",
    "<":"&lt;",
    ">":"&gt;",
    '"':"&quot;",
    "'":"&#39;"
  }[ch]));
}

function renderLoggedOut(actions){
  actions.innerHTML='<a href="/member/join.html" class="btn-nav-primary">회원가입</a><a href="/member/login.html" class="btn-nav-primary secondary">로그인</a>';
}

function renderLoggedIn(actions,supabase,user){
  const label=labelFromUser(user);
  const safeLabel=escapeHtml(label);
  actions.innerHTML=[
    '<span class="member-auth-status" style="font-size:.84rem;font-weight:700;color:#1b3a6b;max-width:170px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" title="'+safeLabel+'">'+safeLabel+'님</span>',
    '<a href="/member/mypage.html" class="btn-nav-primary secondary">마이페이지</a>',
    '<button type="button" id="memberLogoutBtn" class="btn-nav-primary" style="border:0;background:#5a6a7e">로그아웃</button>'
  ].join("");
  const logoutBtn=actions.querySelector("#memberLogoutBtn");
  logoutBtn?.addEventListener("click",async()=>{
    logoutBtn.disabled=true;
    logoutBtn.textContent="로그아웃 중...";
    await supabase.auth.signOut();
    window.location.href="/";
  });
}

async function initAuthNav(){
  const actions=document.querySelector("#site-nav .nav-actions");
  if(!actions)return;
  let supabase;
  try{
    supabase=getSupabaseClient();
  }catch(err){
    renderLoggedOut(actions);
    return;
  }
  const {data:{session}}=await supabase.auth.getSession();
  if(session?.user)renderLoggedIn(actions,supabase,session.user);
  else renderLoggedOut(actions);
  supabase.auth.onAuthStateChange((_event,session)=>{
    if(session?.user)renderLoggedIn(actions,supabase,session.user);
    else renderLoggedOut(actions);
  });
}

initAuthNav();
