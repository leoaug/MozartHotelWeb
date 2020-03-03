package com.mozart.web.aws;

import java.io.InputStream;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class AwsFileUtilities {
	String clientRegion = "sa-east-1";
	
	private AmazonS3 getConnection(){
		return AmazonS3ClientBuilder.standard()
                .withRegion(Regions.SA_EAST_1)
                .build();	
	}
	
	public void fileUpload(String bucketName, String fileObjKeyName, String contentType, InputStream input){
		
		try {
			
			AmazonS3 s3Client = getConnection();
	    	
			// Upload a file as a new object with ContentType and title specified.
			ObjectMetadata metadata = new ObjectMetadata();
			metadata.setContentType(contentType);
			//metadata.setContentType("image/jpeg");
	        PutObjectRequest request = new PutObjectRequest(bucketName, fileObjKeyName, input, metadata);
	        request.setMetadata(metadata);
	        s3Client.putObject(request);
        
		}
        catch(AmazonServiceException e) {
            throw e;
        }
        catch(SdkClientException e) {
        	throw e;
        }
        
	}
	
	public String getFileBase64(String bucketName, String fileObjKeyName) throws Exception
	{
		try{ 
			AmazonS3 s3Client = getConnection();
	    	 
			if(s3Client.doesObjectExist(bucketName, fileObjKeyName))
			{
				S3Object fullObject = s3Client.getObject(new GetObjectRequest(bucketName, fileObjKeyName));
				byte[] byteArray = IOUtils.toByteArray(fullObject.getObjectContent());
				return new String(Base64.encodeBase64(byteArray));
			}
			else{
				return "";
			}
		}
	    catch(AmazonServiceException e) {
	        throw e;
	    }
	    catch(SdkClientException e) {
	    	throw e;
	    } catch (Exception e) {
	    	throw e;
		}
	}
	
	public void fileDelete(String bucketName, String fileObjKeyName) throws Exception
	{
		try
		{	
			AmazonS3 s3Client = getConnection();
	    	
			if(s3Client.doesObjectExist(bucketName, fileObjKeyName))
			{
				s3Client.deleteObject(new DeleteObjectRequest(bucketName, fileObjKeyName));
			}
		}
	    catch(AmazonServiceException e) {
	        throw e;
	    }
	    catch(SdkClientException e) {
	    	throw e;
	    } catch (Exception e) {
	    	throw e;
		}
	}
	
}
