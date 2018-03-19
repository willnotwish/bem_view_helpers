## bem_view_helpers

Very simple gem to avoid repeating class names in Rails views when using BEM

Here's a real life (slim) example

```ruby

= bem_block 'c-teaser', html: { title: "Details of #{course.name}" } do |b|
  = b.header do
    = b.element 'name', course.name, title: true, tag_name: :h5
    = b.element 'dates', course.dates_as_text
  = b.main do |m|
    - membership = course.membership_for( current_user )
    - if membership
      = b.element 'membership' do
        - if membership.confirmed?
          'Your enrolment is 
        = bem_block 'status-label', membership.aasm.human_state, confirmed: membership.confirmed?, provisional: membership.provisional?

    - else
      = b.element 'description' do
        p = course.description
        = b.element 'enrol-button', 'Enrol now'
    
    = b.element 'thumbnail', course.thumbnail

```

which is rendered as

```html
<div title="Details of 10 Weeks to 10k 2018" class="c-teaser">
  <header class="c-teaser__header">
    <h5 class="c-teaser__name c-teaser__name--title">10 Weeks to 10k 2018</h5>
    <div class="status-label status-label--published">Published</div>
    <div class="c-teaser__dates">Started on 25-Jan-2018 (ends on 05-Apr-2018)</div>
  </header>
  <main class="c-teaser__main">
    <div class="c-teaser__membership">Your enrolment is  
      <div class="status-label status-label--confirmed">Confirmed</div>
    </div>
    <div class="c-teaser__thumbnail"><img alt="Thumbnail image of 10 Weeks to 10k 2018" src="http://via.placeholder.com/100x100"></div>
  </main>
</div>
```