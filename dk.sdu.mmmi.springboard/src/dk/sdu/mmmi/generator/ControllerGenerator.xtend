package dk.sdu.mmmi.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import dk.sdu.mmmi.springBoard.Model
import dk.sdu.mmmi.springBoard.Str
import dk.sdu.mmmi.springBoard.Int
import dk.sdu.mmmi.springBoard.Dt
import dk.sdu.mmmi.springBoard.Lon
import dk.sdu.mmmi.springBoard.Bool
import dk.sdu.mmmi.springBoard.ModelType
import dk.sdu.mmmi.springBoard.ListOf
import dk.sdu.mmmi.springBoard.Identifier
import dk.sdu.mmmi.springBoard.Field
import java.util.ArrayList
import dk.sdu.mmmi.springBoard.Service
import dk.sdu.mmmi.springBoard.CRUDActions
import dk.sdu.mmmi.springBoard.Args

class ControllerGenerator {

	val mavenSrcStructure = "src/main/java/"

	def CharSequence generateController(Model model, Service service, String packName, boolean isASubClass) {
		'''
package �packName�.controllers;
import �packName�.models.�model.name�; 
import org.springframework.web.bind.annotation.*;
import dk.sdu.mmmi.project.services.I�model.name�;
�generateServiceImports(service, packName)�
import javax.validation.Valid;
import java.util.List;

@RestController
public class �model.name�Controller {
	private I�model.name� �model.name.toFirstLower�Service;
	
	public �model.name�Controller(I�model.name� �model.name.toFirstLower�Service) {
	        this.�model.name.toFirstLower�Service =  �model.name.toFirstLower�Service;
	}

	�generateCRUDMethods(service, model)�
	�generateServiceMethods(service, model)�

}
'''
	}

	def createController(Model model, Service service, IFileSystemAccess2 fsa, String packName, boolean isASubClass) {
		if (!isASubClass) {
			fsa.generateFile(
				mavenSrcStructure + packName.replace('.', '/') + "/controllers/" + model.name + "Controller.java",
				generateController(model, service, packName, isASubClass)
			)
		}
	}

	def generateServiceImports(Service service, String packName) {
		'''
���		�FOR m : service.methods�
���		�IF m.inp.args !== null�import �packName�.models.�m.inp.args.showType�;�ENDIF�
���		�ENDFOR�
		import �packName�.models.*;
		'''
	}

	def generateCRUDMethods(Service service, Model model) {
		'''
			�FOR a : service.crud.act�
				�IF a == CRUDActions.C�
					
						@PostMapping("/api/�model.name�")
						public boolean create�model.name�(@Valid @RequestBody �model.name� �model.name.toFirstLower�) {
							return �model.name.toFirstLower�Service.create(�model.name.toFirstLower�);
						}	
				�ENDIF�
				�IF a == CRUDActions.R�
					
						@GetMapping("/api/�model.name�/{id}")
						public �model.name� find(Long id) {
							return �model.name.toFirstLower�Service.find(id);
						}						
				�ENDIF�
				�IF a == CRUDActions.U�
					
					    @PostMapping("/api/�model.name�/{id}")
					    public boolean update(Long id) {
					        return �model.name.toFirstLower�Service.update(id);
					    }
					    
					    @PostMapping("/api/�model.name�/{id}")
					    public boolean update(�model.name� �model.name.toFirstLower�) {
					    	return �model.name.toFirstLower�Service.update(�model.name.toFirstLower�);
					    }						
				�ENDIF�
				�IF a == CRUDActions.D�
					
					    @PostMapping("/api/�model.name�/{id}")
					    public boolean delete(Long id) {
					        return �model.name.toFirstLower�Service.delete(id);
					    }
					    
					    @PostMapping("/api/�model.name�/{id}")
					    public boolean delete(�model.name� �model.name.toFirstLower�) {
					    	return  �model.name.toFirstLower�Service.delete(�model.name.toFirstLower�);
					    }   	
				�ENDIF�
			�ENDFOR�
		'''
	}

	def generateServiceMethods(Service service, Model model) {
		'''
			�FOR m : service.methods�
			
				@GetMapping("/api/�model.name�")
				�m.type.show� �m.name�(�IF m.inp.args !== null��m.inp.args.show��ENDIF�){
					return 	�model.name.toFirstLower�Service.�m.name�(�IF m.inp.args !== null��m.inp.args.showName��ENDIF�);
				};
				�ENDFOR�
		'''
	}

	def dispatch CharSequence show(Dt dt) '''DateTime'''

	def dispatch CharSequence show(ListOf lo) '''List<�lo.type.show�>'''

	def dispatch CharSequence show(Str st) '''String'''

	def dispatch CharSequence show(Int in) '''Integer'''

	def dispatch CharSequence show(Lon l) '''Long'''

	def dispatch CharSequence show(Bool b) '''boolean'''

	def dispatch CharSequence show(Identifier id) '''Long'''

	def dispatch CharSequence show(ModelType m) '''�m.base.name�'''

	def dispatch CharSequence show(Args a) '''�a.type.show� �a.name��IF a.next !== null�, �a.next.show��ENDIF�'''

	def CharSequence showName(Args a) '''�a.name�'''
	def CharSequence showType(Args a) '''�a.type.show�'''

}
