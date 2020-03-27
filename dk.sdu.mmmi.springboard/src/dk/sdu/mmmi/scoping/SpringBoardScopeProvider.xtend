/*
 * generated by Xtext 2.20.0
 */
package dk.sdu.mmmi.scoping

import org.eclipse.xtext.scoping.IScope
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import java.util.ArrayList
import org.eclipse.xtext.scoping.Scopes
import dk.sdu.mmmi.springBoard.Field
import java.util.HashSet
import dk.sdu.mmmi.springBoard.Model
import dk.sdu.mmmi.springBoard.SpringBoardPackage.Literals
import dk.sdu.mmmi.springBoard.Exp

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class SpringBoardScopeProvider extends AbstractSpringBoardScopeProvider {
	
	override IScope getScope(EObject context, EReference reference){
		if(context instanceof Exp && reference==Literals.EXP__RIGHT) {
			val seen = new HashSet<Model>
			var model = EcoreUtil2.getContainerOfType(context,Model)
			val candidates = new ArrayList<Field>
			while(model!==null) {
				if(seen.contains(model)) return super.getScope(context, reference) // scope undefined
				seen.add(model)
				candidates.addAll(model.getFields.filter(Field))
				model = model.inh.base
			}
			return Scopes.scopeFor(candidates)
		}
		return super.getScope(context, reference)
	}
}


