## bem_view_helpers

Very simple gem to avoid repeating class names in Rails views when using BEM

Here's a real life (slim) example

```slim

= link_to courses.course_path( course.id ) do
	= bem_block block_name, html: { title: "Click to view details of #{course.name}" } do |b|
		= b.header do
			= b.element 'name', course.name, title: true, tag_name: :h5
			= bem_block 'status-label', course.human_state, published: course.published?, restricted: course.restricted?
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