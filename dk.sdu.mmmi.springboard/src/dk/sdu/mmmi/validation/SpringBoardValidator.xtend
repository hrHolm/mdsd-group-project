/*
 * generated by Xtext 2.20.0
 */
package dk.sdu.mmmi.validation

import org.eclipse.xtext.validation.Check
import dk.sdu.mmmi.springBoard.CRUD
import java.util.regex.Pattern

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SpringBoardValidator extends AbstractSpringBoardValidator {
	
//	public static val INVALID_NAME = 'invalidName'
//
//	@Check
//	def checkGreetingStartsWithCapital(Greeting greeting) {
//		if (!Character.isUpperCase(greeting.name.charAt(0))) {
//			warning('Name should start with a capital', 
//					SpringBoardPackage.Literals.GREETING__NAME,
//					INVALID_NAME)
//		}
//	}

	Pattern cPattern = Pattern.compile("([C]).*([C])")
	Pattern rPattern = Pattern.compile("([R]).*([R])")
	Pattern uPattern = Pattern.compile("([U]).*([U])")
	Pattern dPattern = Pattern.compile("([D]).*([D])")

	@Check
	def checkCrudActions(CRUD crud) {
		
		val matchString = crud.getAct().toString().replace(", ", "")

		val cMatcher = cPattern.matcher(matchString);
		
		if (cMatcher.find()) {
			error('Only one Create method allowed', crud, null);
		}
		
		val rMatcher = rPattern.matcher(matchString);
		
		if (rMatcher.find()) {
			error('Only one Read method allowed', crud, null);
		}
		
		val uMatcher = uPattern.matcher(matchString);
		
		if (uMatcher.find()) {
			error('Only one Update method allowed', crud , null);
		}
		
		val dMatcher = dPattern.matcher(matchString);
		
		if (dMatcher.find()) {
			error('Only one Delete method allowed', crud, null);
		}
		
	}
	
}
