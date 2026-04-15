// Rank On Maps — shared interactivity
(function(){
  // Nav scrolled state
  const nav = document.querySelector('.nav');
  if(nav){
    const onScroll = ()=>nav.classList.toggle('scrolled', window.scrollY > 20);
    window.addEventListener('scroll', onScroll, {passive:true});
    onScroll();
  }

  // Auto-reveal: consistent fade-up for everything
  const sels = ['section .eyebrow','section h2','section .sub','section p.lead','.stat','.feature','.tier','.faq-item','.timeline-step','.industry-card','.testimonial-card','.long-case','.diff-row','.tool','.outcome','.compare-col','.proof','.svc-detail','.case-card'];
  sels.forEach(s=>document.querySelectorAll(s).forEach((el,i)=>{
    el.classList.add('reveal');
    el.classList.add('d'+(i%6));
  }));
  const io = new IntersectionObserver((entries)=>{
    entries.forEach(e=>{ if(e.isIntersecting){ e.target.classList.add('in'); io.unobserve(e.target); }});
  },{threshold:.12, rootMargin:'0px 0px -60px 0px'});
  document.querySelectorAll('.reveal').forEach(el=>io.observe(el));

  // Mobile hamburger menu
  const hamburger = document.querySelector('.hamburger');
  const navLinks = document.querySelector('.nav-links');
  if(hamburger && navLinks){
    hamburger.addEventListener('click',()=>{
      hamburger.classList.toggle('open');
      navLinks.classList.toggle('open');
      document.body.classList.toggle('nav-open');
    });
    navLinks.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{
      hamburger.classList.remove('open');
      navLinks.classList.remove('open');
      document.body.classList.remove('nav-open');
    }));
  }
})();
